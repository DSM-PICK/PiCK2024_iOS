import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class MainViewController: BaseVC<MainViewModel>, Stepper {
    
    private let disposeBag = DisposeBag()
    
    public let steps = PublishRelay<Step>()
    
    private var itemSize: CGSize {
        let height = self.view.frame.height - (outingPassView.isHidden ? 350 : 424)
        return CGSize(width: self.view.frame.width - 48, height: height)
    }
    private let itemSpacing = 14.0
    private lazy var insetX = CGFloat(self.view.frame.width - self.itemSize.width) / 2.0
    private lazy var cellViewSize = CGRect(
        x: 0,
        y: 0,
        width: itemSize.width,
        height: itemSize.height
    )
    private var outingPassViewHeight: CGFloat {
        return outingPassView.isHidden ? 0 : 74
    }
    
    private let pickLabel = UILabel().then {
        $0.text = "PiCK"
        $0.textColor = .primary300
        $0.font = .heading6B
    }
    private let alertButton = UIButton(type: .system).then {
        $0.setImage(.alertIcon, for: .normal)
    }
    private let settingButton = UIButton(type: .system).then {
        $0.setImage(.settingIcon, for: .normal)
    }
    private let studentInfoLabel = UILabel().then {
        $0.text = "2학년 4반 13번 조영준"
        $0.textColor = .neutral100
        $0.font = .subTitle2B
    }
    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 34
        $0.backgroundColor = .primary1000
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    private let labelStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.spacing = 53
    }
    private let scheduleButton = PiCKMainButton(type: .system).then {
        $0.getter(text: "일정")
        $0.setImage(.scheduleIcon, for: .normal)
    }
    private let applyButton =  PiCKMainButton(type: .system).then {
        $0.getter(text: "신청")
        $0.setImage(.applyIcon, for: .normal)
    }
    private let schoolMealButton = PiCKMainButton(type: .system).then {
        $0.getter(text: "급식")
        $0.setImage(.schoolMealIcon, for: .normal)
    }
    private let profileButton = PiCKMainButton(type: .system).then {
        $0.getter(text: "my")
        $0.setImage(.profileIcon, for: .normal)
    }
    private lazy var outingPassView = AnyView().then {
        $0.isHidden = true
    }
    private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = itemSize
        $0.minimumLineSpacing = itemSpacing
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .primary1000
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = false
        $0.bounces = false
        $0.contentInset = UIEdgeInsets(top: 0, left: self.insetX, bottom: 0, right: self.insetX)
        $0.clipsToBounds = true
        $0.decelerationRate = .fast
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
    }
    private let pageControl = PiCKPageControl().then {
        $0.numberOfPages = 3
        $0.currentPage = 0
        $0.backgroundColor = .primary1000
        $0.currentPageIndicatorTintColor = .primary300
        $0.pageIndicatorTintColor = .neutral600
        $0.allowsContinuousInteraction = false
        $0.isEnabled = false
        $0.dotRadius = 4
        $0.dotSpacings = 4
    }
    public override func attribute() {
        view.backgroundColor = .primary1000
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: alertButton)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    public override func bind() {
        scheduleButton.rx.tap
            .bind { [weak self] in
                self?.steps.accept(PiCKStep.scheduleRequired)
            }.disposed(by: disposeBag)
        
        applyButton.rx.tap
            .bind { [weak self] in
                self?.steps.accept(PiCKStep.applyRequired)
            }.disposed(by: disposeBag)
        
        schoolMealButton.rx.tap
            .bind { [weak self] in
                self?.steps.accept(PiCKStep.schoolMealRequired)
            }.disposed(by: disposeBag)
        
        profileButton.rx.tap
            .bind { [weak self] in
                self?.steps.accept(PiCKStep.profileRequired)
            }.disposed(by: disposeBag)
    }
    public override func addView() {
        [
            pickLabel,
            studentInfoLabel,
            buttonStackView,
            outingPassView,
            collectionView,
            pageControl
        ].forEach { view.addSubview($0) }
        
        [
            scheduleButton,
            applyButton,
            schoolMealButton,
            profileButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
    
    }
    public override func setLayout() {
        pickLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(55)
            $0.left.equalToSuperview().inset(24)
        }
        studentInfoLabel.snp.makeConstraints {
            $0.top.equalTo(pickLabel.snp.bottom).offset(18)
            $0.left.equalToSuperview().inset(24)
        }
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(studentInfoLabel.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(24)
        }
        outingPassView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(outingPassViewHeight)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(outingPassView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(75)
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(12)
        }
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.identifier, for: indexPath) as? MainCell
        else {
            return UICollectionViewCell()
        }
        switch indexPath.row {
            case 0:
                cell.view = TimeTableCollectionView(frame: cellViewSize)
                return cell
            case 1:
                cell.view = SchoolMealCollectionView(frame: cellViewSize)
                return cell
            case 2:
                cell.view = NoticeCollectionView(frame: cellViewSize)
                return cell
            default:
                return cell
        }
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScrollAtMain(scrollView)
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = itemSize.width + itemSpacing
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
}
