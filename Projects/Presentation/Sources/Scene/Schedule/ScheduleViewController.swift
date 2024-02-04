import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class ScheduleViewController: BaseVC<ScheduleViewModel> {
    
    private lazy var viewSize = CGRect(
        x: 0,
        y: 0,
        width: self.view.frame.width - 46,
        height: self.view.frame.height - 184)
    
    private lazy var segementedTimetableView = ScrollTimeTableView(frame: viewSize)
    private let segementedCalendarView = AcademicCalendarView()
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "일정"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var segementedControl = UISegmentedControl(items: [
        "시간표",
        "학사일정"
    ]).then {
        $0.selectedSegmentIndex = 0
    }
    
    public override func attribute() {
        navigationItem.titleView = navigationTitleLabel
        navigationItem.hidesBackButton = false
    }
    public override func addView() {
        [
            segementedControl,
            segementedTimetableView,
            segementedCalendarView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        segementedControl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(90)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(36)
        }
        segementedTimetableView.snp.makeConstraints {
            $0.top.equalTo(segementedControl.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(23)
            $0.bottom.equalToSuperview().inset(74)
        }
        segementedCalendarView.snp.makeConstraints {
            $0.top.equalTo(segementedControl.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(23)
            $0.bottom.equalToSuperview().inset(74)
        }
        
        self.segementedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        self.didChangeValue(segment: self.segementedControl)
    }
       

     
     @objc private func didChangeValue(segment: UISegmentedControl) {
       self.shouldHideFirstView = segment.selectedSegmentIndex != 0
     }
    
    var shouldHideFirstView: Bool? {
      didSet {
        guard let shouldHideFirstView = self.shouldHideFirstView else { return }
        self.segementedTimetableView.isHidden = shouldHideFirstView
        self.segementedCalendarView.isHidden = !self.segementedTimetableView.isHidden
      }
    }
}
