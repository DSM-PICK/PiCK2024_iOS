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
    private let mainDataLoadRelay = PublishRelay<Void>()
    private let userInfoLoadRelay = PublishRelay<Void>()
    private let classroomReturnRelay = PublishRelay<Void>()
    
    //CellDataRelay
    private let todayTimeTableRelay = PublishRelay<Void>()
    private let todaySchoolMealRelay = PublishRelay<String>()
    private let todayNoticeLoadRelay = PublishRelay<Void>()
    private let clickNoticeCell = PublishRelay<UUID>()
    
    //ButtonRelay
    private let viewNoticeButtonRelay = PublishRelay<Void>()
    private let outingPassButtonRelay = PublishRelay<Void>()
    
    private let todayTimeTable = BehaviorRelay<[TimeTableEntityElement]>(value: [])
    private let todaySchoolMeal = BehaviorRelay<[(Int, String, MealEntityElement)]>(value: [])
    private let noticeList = BehaviorRelay<NoticeListEntity>(value: [])
    
    private var passType: OutingPassType? = nil
    
    private let date = Date()
    private lazy var todayDate = date.toString(type: .fullDate)
    
    private lazy var cellViewSize = CGRect(
        x: 0,
        y: 0,
        width: collectionView.frame.width - 48,
        height: collectionView.frame.height - (outingPassView.isHidden ? 0 : 74)
    )
    
    private var itemSize: CGSize {
        let height = self.view.frame.height - (outingPassView.isHidden ? 365 : 445)
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
        $0.imageEdgeInsets = .init(
            top: 5,
            left: 5,
            bottom: 5,
            right: 5
        )
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
        if self.passType?.rawValue == OutingPassType.classroom.rawValue {
            self.viewReload(isHidden: true)
            self.classroomReturnRelay.accept(())
        } else {
            self.outingPassButtonRelay.accept(())
        }
    })
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
        $0.clipsToBounds = true
        $0.decelerationRate = .fast
        $0.contentInsetAdjustmentBehavior = .never
        $0.contentInset = .init(
            top: 0,
            left: self.insetX,
            bottom: 0,
            right: self.insetX
        )
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
        mainDataLoadRelay.accept(())
        userInfoLoadRelay.accept(())
        //cellRelay
        todayTimeTableRelay.accept(())
        todaySchoolMealRelay.accept(todayDate)
        todayNoticeLoadRelay.accept(())
    }
    public override func bind() {
        let input = MainViewModel.Input(
            mainDataLoad: mainDataLoadRelay.asObservable(),
            userInfoLoad: userInfoLoadRelay.asObservable(),
            classroomReturn: classroomReturnRelay.asObservable(),
            todayTimeTableLoad: todayTimeTableRelay.asObservable(),
            todaySchoolMealLoad: todaySchoolMealRelay.asObservable(),
            noticeListLoad: todayNoticeLoadRelay.asObservable(),
            profileButtonDidClick: profileButton.rx.tap.asObservable(),
            scheduleButtonDidClick: scheduleButton.rx.tap.asObservable(),
            applyButtonDidClick: applyButton.rx.tap.asObservable(),
            schoolMealButtonDidClick: schoolMealButton.rx.tap.asObservable(),
            selfStudyTeacherButtonDidClick: selfStudyTeacherButton.rx.tap.asObservable(),
            outingPassButtonDidClick: outingPassButtonRelay.asObservable(),
            noticeButtonDidClick: viewNoticeButtonRelay.asObservable(),
            noticeCellDidClick: clickNoticeCell.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.userProfileData.asObservable()
            .subscribe(
                onNext: {
                    self.userInfoLabel.text = "\($0.grade)학년 \($0.classNum)반 \($0.num)번 \($0.name)"
                }
            )
            .disposed(by: disposeBag)
        
        output.mainData.asObservable()
            .bind(
                onNext: { data in
                    if data?.type == OutingPassType.classroom.rawValue {
                        self.passType = .classroom
                        self.outingPassView.setup(
                            topLabel: "현재 \(data?.userName ?? "")님은",
                            bottomLabel: "\(data?.classroom ?? "")에 있습니다.",
                            buttonTitle: "돌아가기",
                            pointText: "\(data?.classroom ?? "")"
                        )
                        self.viewReload(isHidden: false)
                    } else if data?.type ==  OutingPassType.applicatoin.rawValue {
                        self.passType = .applicatoin
                        self.outingPassView.setup(
                            topLabel: "\(data?.userName ?? "")님의 외출 시간은",
                            bottomLabel: "\(data?.startTime ?? "") ~ \(data?.endTime ?? "") 입니다.",
                            buttonTitle: "외출증 보러가기",
                            pointText: "\(data?.startTime ?? "") ~ \(data?.endTime ?? "")"
                        )
                        self.viewReload(isHidden: false)
                    } else if data?.type == OutingPassType.earlyReturn.rawValue {
                        self.passType = .earlyReturn
                        self.outingPassView.setup(
                            topLabel: "\(data?.userName ?? "")님의 조기 귀가 가능 시간은",
                            bottomLabel: "\(data?.startTime ?? "") 입니다.",
                            buttonTitle: "외출증 보러가기",
                            pointText: "\(data?.startTime ?? "")"
                        )
                        self.viewReload(isHidden: false)
                    } else {
                        self.viewReload(isHidden: true)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        output.todayTimeTableData.asObservable()
            .subscribe(
                onNext: {
                    self.todayTimeTable.accept($0)
                    self.collectionView.reloadData()
                }
            )
            .disposed(by: disposeBag)
        
        output.todaySchoolMealData.asObservable()
            .subscribe(
                onNext: {
                    self.todaySchoolMeal.accept($0)
                    self.collectionView.reloadData()
                }
            )
            .disposed(by: disposeBag)
        
        output.noticeListData.asObservable()
            .subscribe(
                onNext: {
                    self.noticeList.accept($0)
                    self.collectionView.reloadData()
                }
            )
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
    
    private func viewReload(isHidden: Bool) {
        self.outingPassView.isHidden = isHidden
        self.outingPassView.snp.remakeConstraints {
            $0.height.equalTo(self.outingPassViewHeight)
        }
        self.collectionViewLayout.itemSize = self.itemSize
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection
        section: Int
    ) -> Int {
        return 3
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCell.identifier,
            for: indexPath
        ) as? MainCell
        else {
            return UICollectionViewCell()
        }
        switch indexPath.row {
            case 0:
                let view = TimeTableCollectionView(frame: cellViewSize)
                view.setup(todayTimeTable: todayTimeTable.value)
                cell.configureUI(
                    title: "시간표",
                    buttonVisiable: true,
                    dateVisiable: false
                )
                cell.view = view
                return cell
            case 1:
                let view =  SchoolMealCollectionView(frame: cellViewSize)
            view.setup(todaySchoolMeal: todaySchoolMeal.value)
                cell.configureUI(
                    title: "급식",
                    buttonVisiable: true,
                    dateVisiable: false
                )
                cell.view = view
                return cell
            case 2:
                let view = NoticeCollectionView(frame: cellViewSize)
                view.clickNoticeCell = { [weak self] id in
                    self?.clickNoticeCell.accept(id)
                }
                view.setup(noticeList: noticeList.value)
                cell.configureUI(
                    title: "공지",
                    buttonVisiable: false,
                    dateVisiable: true
                )
                cell.moreButton.rx.tap
                    .bind(
                        onNext: {
                            self.viewNoticeButtonRelay.accept(())
                        }
                    )
                    .disposed(by: cell.disposeBag)
                cell.view = view
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
