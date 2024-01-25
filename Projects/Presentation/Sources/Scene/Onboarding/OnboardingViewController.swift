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
    
    private let logoImageView = UIView().then { //임시
        $0.backgroundColor = .gray
    }
    private let pickLabel = UILabel().then {
        $0.text = "PiCK"
        $0.textColor = .primary300
        $0.font = .heading3
    }
    private let explainLabel = UILabel().then {
        $0.text = "편리한 학교 생활을편리한 학교 생활을\nㅍ편리한 학교 생활을"
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
        $0.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)
        $0.alwaysBounceVertical = false
        $0.bounces = false
    }
    private let pageControl = PageControl().then {
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
    private let loginButton = PiCKLoginButton(type: .system).then {
        $0.isEnabled = true
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
            pickLabel,
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
            $0.width.height.equalTo(50)
        }
        pickLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(194)
            $0.left.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(pickLabel.snp.bottom).offset(15)
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
