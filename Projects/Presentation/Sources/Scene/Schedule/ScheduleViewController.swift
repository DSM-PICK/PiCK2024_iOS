import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ScheduleViewController: BaseViewController<ScheduleViewModel> {
    
    private let shouldHideFirstViewRelay = BehaviorRelay<Bool>(value: true)
    private let academicScheduleLoadRelay = PublishRelay<String>()
    private let timeTableLoadRelay = PublishRelay<Void>()
    
    private let date = Date()
    private lazy var month = date.toStringEng(type: .fullMonth)
    
    private lazy var viewSize = CGRect(
        x: 0,
        y: 0,
        width: self.view.frame.width - 46,
        height: self.view.frame.height - 184
    )
    
    private lazy var segmentedTimetableView = ScrollTimeTableView(
        frame: viewSize
    )
    private lazy var segmentedCalendarView = AcademicScheduleView(
        clickToAction: { month in
            self.month = month
            self.academicScheduleLoadRelay.accept(self.month)
        },
        frame: viewSize
    )
    private let navigationTitleLabel = UILabel().then {
        $0.text = "일정"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var segmentedControl = PiCKSegmentedControl(items: [
        "시간표",
        "학사일정"
    ])
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func bindAction() {
        timeTableLoadRelay.accept(())
        academicScheduleLoadRelay.accept(self.month)
    }
    
    var shouldHideFirstView: Observable<Bool> {
        return shouldHideFirstViewRelay.asObservable()
    }
    public override func bind() {
        let input = ScheduleViewModel.Input(
            academicScheduleLoad: academicScheduleLoadRelay.asObservable(),
            timeTableLoad: timeTableLoadRelay.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        segmentedControl.rx.selectedSegmentIndex
            .map { $0 != 0 }
            .bind(to: shouldHideFirstViewRelay)
            .disposed(by: disposeBag)
        
        shouldHideFirstView
            .subscribe(
                onNext: { [weak self] shouldHide in
                    self?.segmentedTimetableView.isHidden = shouldHide
                    self?.segmentedCalendarView.isHidden = !shouldHide
                }
            )
            .disposed(by: disposeBag)
        
        output.academicScheduleDataLoad.asObservable()
            .subscribe(
                onNext: { academicSchedule in
                    self.segmentedCalendarView.setup(
                        academicSchedule: academicSchedule
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.timeTableDataLoad.asObservable()
            .subscribe(
                onNext: { timeTableData in
                    self.segmentedTimetableView.timeTableSetup(
                        timeTableData: timeTableData
                    )
                }
            )
            .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            segmentedControl,
            segmentedTimetableView,
            segmentedCalendarView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(36)
        }
        segmentedTimetableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.left.right.equalToSuperview().inset(23)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        segmentedCalendarView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(23)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
