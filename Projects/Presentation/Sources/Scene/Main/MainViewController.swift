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
    
    private lazy var itemSize = CGSize(
        width: self.view.frame.width - 48,
        height: self.view.frame.height - 444
    )
    private let itemSpacing = 14.0
    private lazy var insetX = CGFloat(self.view.frame.width - self.itemSize.width) / 2.0
    private lazy var cellViewSize = CGRect(
        x: 0,
        y: 0,
        width: collectionView.frame.width - 48,
        height: self.view.frame.height - 450
    )
    
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
    private let collectionButtonStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private let timeTableCollectionButton = PiCKMainCollectionButton(type: .system).then {
        $0.setTitle("시간표", for: .normal)
        $0.isSelected = true
        $0.tag = 0
    }
    private let schoolMealCollectionButton = PiCKMainCollectionButton(type: .system).then {
        $0.setTitle("급식", for: .normal)
        $0.tag = 1
    }
    private let noticeCollectionButton = PiCKMainCollectionButton(type: .system).then {
        $0.setTitle("공지사항", for: .normal)
        $0.tag = 2
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
    lazy var radioButtons = [
        timeTableCollectionButton,
        schoolMealCollectionButton,
        noticeCollectionButton
    ]
    public override func attribute() {
        view.backgroundColor = .primary1000
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: settingButton),
            UIBarButtonItem(customView: alertButton)
        ]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        radioButtons.forEach { button in
            button.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.clickRadioButtons(selectedButton: button)
                }).disposed(by: disposeBag)
        }
    }
    public override func addView() {
        [
            pickLabel,
            studentInfoLabel,
            buttonStackView,
            collectionButtonStackView,
            collectionView
        ].forEach { view.addSubview($0) }
        
        [
            scheduleButton,
            applyButton,
            schoolMealButton,
            profileButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        
        [
            timeTableCollectionButton,
            schoolMealCollectionButton,
            noticeCollectionButton
        ].forEach { collectionButtonStackView.addArrangedSubview($0) }
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
        collectionButtonStackView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(44)
            $0.left.equalToSuperview().inset(24)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(collectionButtonStackView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(104)
        }
    }
    
    private func clickRadioButtons(selectedButton: PiCKMainCollectionButton) {
        selectedButton.isSelected.toggle()
        
        radioButtons.filter { $0 != selectedButton }.forEach { button in
            button.isSelected = false
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
