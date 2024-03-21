import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class MainViewController: BaseViewController<MainViewModel> {
    
    //DataRelay
    private let userInfoLoadRelay = PublishRelay<Void>()
    private let classroomCheckRelay = PublishRelay<Void>()
    private let classroomReturnRelay = PublishRelay<Void>()
    
    //CellDataRelay
    private let todayTimeTableRelay = PublishRelay<Void>()
    private let todaySchoolMealRelay = PublishRelay<String>()
    private let todayNoticeLoadRelay = PublishRelay<Void>()
    
    //ButtonRelay
    private let viewNoticeButtonRelay = PublishRelay<Void>()
    private let outingPassButtonRelay = PublishRelay<Void>()
    
    let todayTimeTable = BehaviorRelay<[TimeTableEntityElement]>(value: [])
    let todaySchoolMeal = BehaviorRelay<[String: [String]]>(value: .init())
    let todayNoticeList = BehaviorRelay<TodayNoticeListEntity>(value: [])
    
    private let date = Date()
    private lazy var todayDate = date.toString(type: .fullDate)
    
    private var itemSize: CGSize {
        let height = self.view.frame.height - (outingPassView.isHidden ? 355 : 435)
        return CGSize(width: self.view.frame.width - 48, height: height)
    }
    private let itemSpacing = 14.0
    private lazy var insetX = CGFloat(self.view.frame.width - self.itemSize.width) / 2.0
    private var outingPassViewHeight: CGFloat {
        return outingPassView.isHidden ? 0 : 74
    }
    
    private let pickLogoImageView = UIImageView(image: .PiCKLogo).then {
        $0.contentMode = .scaleAspectFit
    }
    private let profileButton = UIButton(type: .system).then {
        $0.setImage(.profileIcon, for: .normal)
        $0.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    private let userInfoLabel = UILabel().then {
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
    private let selfStudyTeacherButton = PiCKMainButton(type: .system).then {
        $0.getter(text: "선생님 조회")
        $0.setImage(.selfStudyTeacherIcon, for: .normal)
    }
    private lazy var outingPassView = PassView(clickToAction: {
        //        self.outingPassButtonRelay.accept(())
        self.classroomReturnRelay.accept(())
    }).then {
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
        $0.register(
            MainCell.self,
            forCellWithReuseIdentifier: MainCell.identifier
        )
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
    
    public override func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
    public override func configureNavgationBarLayOutSubviews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: pickLogoImageView)
    }
    public override func attribute() {
        view.backgroundColor = .primary1000
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    public override func bindAction() {
        userInfoLoadRelay.accept(())
        classroomCheckRelay.accept(())
        
        todayTimeTableRelay.accept(())
        todaySchoolMealRelay.accept(todayDate)
        todayNoticeLoadRelay.accept(())
    }
    public override func bind() {
        let input = MainViewModel.Input(
            userInfoLoad: userInfoLoadRelay.asObservable(),
            classroomCheckLoad: classroomCheckRelay.asObservable(),
            classroomReturn: classroomReturnRelay.asObservable(),
            todayTimeTableLoad: todayTimeTableRelay.asObservable(),
            todaySchoolMealLoad: todaySchoolMealRelay.asObservable(),
            todayNoticeListLoad: todayNoticeLoadRelay.asObservable(),
            profileButtonDidClick: profileButton.rx.tap.asObservable(),
            scheduleButtonDidClick: scheduleButton.rx.tap.asObservable(),
            applyButtonDidClick: applyButton.rx.tap.asObservable(),
            schoolMealButtonDidClick: schoolMealButton.rx.tap.asObservable(),
            selfStudyTeacherButtonDidClick: selfStudyTeacherButton.rx.tap.asObservable(),
            outingPassButtonDidClick: outingPassButtonRelay.asObservable(),
            noticeButtonDidClick: viewNoticeButtonRelay.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.userProfileData.asObservable()
            .subscribe(
                onNext: {
                    self.userInfoLabel.text = "\($0.grade)학년 \($0.classNum)반 \($0.num)번 \($0.name)"
                }
            )
            .disposed(by: disposeBag)
        
        output.classroomCheckData.asObservable()
            .subscribe(
                onNext: {
                    self.outingPassView.setup(
                        topLabel: "현재",
                        bottomLabel: "\($0.userName)님은 \($0.classroom)에 있습니다.",
                        buttonTitle: "돌아가기",
                        firstPointText: "\($0.classroom)",
                        secondPoinText: "dd"
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.todayTimeTableData.asObservable()
            .subscribe(
                onNext: {
                    self.todayTimeTable.accept($0)
                }
            )
            .disposed(by: disposeBag)
        
        output.todaySchoolMealData.asObservable()
//            .map { $0.meals }
            .subscribe(
                onNext: {
                    self.todaySchoolMeal.accept($0.meals)
                }
            )
            .disposed(by: disposeBag)
        
        output.todayNoticeListData.asObservable()
            .bind(to: todayNoticeList)
            .disposed(by: disposeBag)
        
    }
    public override func addView() {
        [
            userInfoLabel,
            buttonStackView,
            outingPassView,
            collectionView,
            pageControl
        ].forEach { view.addSubview($0) }
        
        [
            scheduleButton,
            applyButton,
            schoolMealButton,
            selfStudyTeacherButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        
    }
    public override func setLayout() {
        pickLogoImageView.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(27)
        }
        userInfoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalToSuperview().inset(24)
        }
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(userInfoLabel.snp.bottom).offset(32)
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
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCell.identifier,
            for: indexPath
        ) as? MainCell
        else {
            return UICollectionViewCell()
        }
        cell.registerCellIndex(index: indexPath.row)
        cell.moreButton.rx.tap
            .subscribe(
                onNext: {
                    self.viewNoticeButtonRelay.accept($0)
                }
            ).disposed(by: disposeBag)
        cell.setup(
            todayTimeTable: todayTimeTable.value,
            todaySchoolMeal: todaySchoolMeal.value,
            todayNoticeList: todayNoticeList.value
        )
        return cell
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScrollAtMain(scrollView)
    }
    
}
