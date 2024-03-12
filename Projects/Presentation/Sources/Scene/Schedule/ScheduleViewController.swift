import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class ScheduleViewController: BaseViewController<ScheduleViewModel>, Stepper {
    
    public let steps = PublishRelay<Step>()
    private let academicScheduleLoadRelay = PublishRelay<String>()
    private let timeTableLoadRelay = PublishRelay<String>()
    
    private let date = Date()
    private lazy var month = date.toStringEng(DateFormatIndicated.fullMonth.rawValue)
    
    private lazy var viewSize = CGRect(
        x: 0,
        y: 0,
        width: self.view.frame.width - 46,
        height: self.view.frame.height - 184
    )
    
    private lazy var segmentedTimetableView = ScrollTimeTableView(frame: viewSize)
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
        timeTableLoadRelay.accept(date.toString(DateFormatIndicated.fullDate.rawValue))
       academicScheduleLoadRelay.accept(self.month)
    }
    public override func bind() {
        self.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        self.didChangeValue(segment: self.segmentedControl)
        
        let input = ScheduleViewModel.Input(
            academicScheduleLoad: academicScheduleLoadRelay.asObservable(),
            timeTableLoad: timeTableLoadRelay.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.academicScheduleDataLoad.asObservable()
            .subscribe(
                onNext: { data in
                    self.segmentedCalendarView.setup(
                        academicSchedule: data
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.dateLoad.asObservable()
            .subscribe(
                onNext: { date in
                    self.segmentedTimetableView.setup(date: date)
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
            $0.top.equalToSuperview().inset(90)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(36)
        }
        segmentedTimetableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(23)
            $0.bottom.equalToSuperview().inset(74)
        }
        segmentedCalendarView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(23)
            $0.bottom.equalToSuperview().inset(74)
        }
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideFirstView = segment.selectedSegmentIndex != 0
    }
    
    var shouldHideFirstView: Bool? {
        didSet {
            guard let shouldHideFirstView = self.shouldHideFirstView else { return }
            self.segmentedTimetableView.isHidden = shouldHideFirstView
            self.segmentedCalendarView.isHidden = !self.segmentedTimetableView.isHidden
        }
    }
}
