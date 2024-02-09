import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow
import RxGesture

import Core
import DesignSystem

public class ApplicationViewController: BaseVC<ApplicationViewModel> {
    
    private let applicationDate = Date()
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "신청"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let weekendMealApplicationLabel = UILabel().then {
        $0.text = "주말 급식 신청"
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private let explanationLabel = UILabel().then {
        $0.text = "신청 여부는 담임 선생님이 확인 후 영양사 선생님에게 전달돼요."
        $0.textColor = .neutral300
        $0.font = .body3
    }
    private let weekendMealApplicationView = UIView().then {
        $0.backgroundColor = .primary1200
        $0.layer.cornerRadius = 8
    }
    private lazy var currnetMonthWeekendMealApplicationLabel = UILabel().then {
        $0.text = "\(applicationDate.toString(DateFormatIndicated.month.rawValue)) 주말 급식 신청"
        $0.textColor = .black
        $0.font = .body3
    }
    private let applicationButton = PiCKApplicationButton(type: .system).then {
        $0.setTitle("신청", for: .normal)
    }
    private let noApplicationButton = PiCKApplicationButton(type: .system).then {
        $0.setTitle("미신청", for: .normal)
    }
    private let additionApplicationLabel = UILabel().then {
        $0.text = "추가 신청"
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.backgroundColor = .clear
        $0.distribution = .fillEqually
    }
    private let classroomChangeApplicationView = PiCKApplicationView().then {
        $0.getter(text: "교실 이동")
    }
    private let outingApplicationView = PiCKApplicationView().then {
        $0.getter(text: "외출 신청")
    }
    private let earlyLeaveApplicationView = PiCKApplicationView().then {
        $0.getter(text: "조기 귀가 신청")
    }
    
    public override func attribute() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func addView() {
        [
            weekendMealApplicationLabel,
            explanationLabel,
            weekendMealApplicationView,
            additionApplicationLabel,
            stackView
        ].forEach { view.addSubview($0) }
        
        [
            currnetMonthWeekendMealApplicationLabel,
            applicationButton,
            noApplicationButton
        ].forEach { weekendMealApplicationView.addSubview($0) }
        
        [
            classroomChangeApplicationView,
            outingApplicationView,
            earlyLeaveApplicationView
        ].forEach { stackView.addArrangedSubview($0) }
    }
    public override func setLayout() {
        weekendMealApplicationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(126)
            $0.left.equalToSuperview().inset(24)
        }
        explanationLabel.snp.makeConstraints {
            $0.top.equalTo(weekendMealApplicationLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().inset(24)
        }
        weekendMealApplicationView.snp.makeConstraints {
            $0.top.equalTo(explanationLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
        currnetMonthWeekendMealApplicationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        applicationButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(94)
            $0.height.equalTo(34)
            $0.width.equalTo(70)
        }
        noApplicationButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(applicationButton.snp.right).offset(8)
            $0.height.equalTo(34)
            $0.width.equalTo(70)
        }
        additionApplicationLabel.snp.makeConstraints {
            $0.top.equalTo(weekendMealApplicationView.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(24)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(additionApplicationLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(140)
        }
    }
    
}
