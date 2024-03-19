import UIKit

import SnapKit
import Then
import RxFlow
import RxSwift
import RxCocoa

import Core
import DesignSystem

public class OnboardingViewController: UIViewController, Stepper {

    public var steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    private lazy var cellSize: CGFloat =  self.view.frame.width - 94
    
    private let logoImageView = UIImageView(image: .PiCKLogo)
    private let explainLabel = UILabel().then {
        $0.text = "학교 생활을 한 곳에서, PiCK"
        $0.textColor = .neutral400
        $0.font = .body2
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: cellSize, height: cellSize)
    }
    private lazy var onboardingCollectionview = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.bounces = false
        $0.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)
    }
    private let pageControl = PiCKPageControl().then {
        $0.numberOfPages = 3
        $0.currentPage = 0
        $0.backgroundColor = .white
        $0.currentPageIndicatorTintColor = .primary300
        $0.pageIndicatorTintColor = .neutral600
        $0.allowsContinuousInteraction = false
        $0.isEnabled = false
        $0.dotRadius = 4
        $0.dotSpacings = 4
    }
    private let loginButton = UIButton(type: .system).then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .buttonS
        $0.backgroundColor = .primary400
        $0.layer.cornerRadius = 4
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addView()
        setLayout()
    }

    private func attribute() {
        view.backgroundColor = .white
        
        onboardingCollectionview.delegate = self
        onboardingCollectionview.dataSource = self
        
        loginButton.rx.tap
            .bind(onNext: {
                self.steps.accept(PiCKStep.loginRequired)
            }).disposed(by: disposeBag)
    }
    private func addView() {
        [
            logoImageView,
            explainLabel,
            onboardingCollectionview,
            pageControl,
            loginButton
        ].forEach { view.addSubview($0) }
    }
    private func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(144)
            $0.left.equalToSuperview().inset(24)
            $0.width.height.equalTo(120)
            $0.height.equalTo(68)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(15)
            $0.left.equalToSuperview().inset(24)
        }
        onboardingCollectionview.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(43)
            $0.bottom.equalToSuperview().inset(243)
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(onboardingCollectionview.snp.bottom).offset(40)
        }
        loginButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(84)
            $0.height.equalTo(47)
        }
    }

}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.identifier, for: indexPath) as? OnboardingCell
        else {
            return UICollectionViewCell()
        }
        switch indexPath.row {
            case 0:
                cell.imageView.image = .onboardingImage1
                return cell
            case 1:
                cell.imageView.image = .onboardingImage2
                return cell
            case 2:
                cell.imageView.image = .onboardingImage3
                return cell
            default:
                return cell
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScroll(scrollView)
    }

}
