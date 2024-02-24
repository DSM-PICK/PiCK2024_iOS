import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow
import RxGesture

import Core
import DesignSystem

public class ApplyViewController: BaseViewController<ApplyViewModel>, Stepper {
    
    public let steps = PublishRelay<Step>()
    
    private let applyDate = Date()
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "신청"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let weekendMealApplyLabel = UILabel().then {
        $0.text = "주말 급식 신청"
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private let explanationLabel = UILabel().then {
        $0.text = "신청 여부는 담임 선생님이 확인 후 영양사 선생님에게 전달돼요."
        $0.textColor = .neutral300
        $0.font = .body3
    }
    private let weekendMealApplyView = UIView().then {
        $0.backgroundColor = .primary1200
        $0.layer.cornerRadius = 8
    }
    private lazy var currnetMonthWeekendMealApplyLabel = UILabel().then {
        $0.text = "\(applyDate.toString(DateFormatIndicated.month.rawValue)) 주말 급식 신청"
        $0.textColor = .black
        $0.font = .body3
    }
    private let applyButton = PiCKWeekendMealApplyButton(type: .system).then {
        $0.setTitle("신청", for: .normal)
    }
    private let noApplyButton = PiCKWeekendMealApplyButton(type: .system).then {
        $0.setTitle("미신청", for: .normal)
    }
    private let additionApplyLabel = UILabel().then {
        $0.text = "추가 신청"
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private let applyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.backgroundColor = .clear
        $0.distribution = .fillEqually
    }
    private let classroomMoveApplyView = PiCKApplyView().then {
        $0.getter(text: "교실 이동", image: .pencilIcon)
    }
    private let outingApplyView = PiCKApplyView().then {
        $0.getter(text: "외출 신청", image: .bikeIcon)
    }
    private let earlyLeaveApplyView = PiCKApplyView().then {
        $0.getter(text: "조기 귀가 신청", image: .bikeIcon)
    }
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func bind() {
        
        //버튼을 radio로 할지 고민해보기
        applyButton.rx.tap
            .bind { [weak self] in
                let modal = PiCKAlert(
                    questionText: "주말 급식을 신청하시겠습니까?",
                    cancelButtonTitle: "취소",
                    checkButtonTitle: "확인",
                    clickToAction: {
                        self?.applyButton.isSelected = true
                    })
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self?.present(modal, animated: true)
            }.disposed(by: disposeBag)
        
        noApplyButton.rx.tap
            .bind { [weak self] in
                let modal = PiCKAlert(
                    questionText: "주말 급식 신청을 취소하시겠습니까?",
                    cancelButtonTitle: "취소",
                    checkButtonTitle: "확인",
                    clickToAction: {
                        self?.noApplyButton.isSelected = true
                    })
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self?.present(modal, animated: true)
            }.disposed(by: disposeBag)
        
        classroomMoveApplyView.rx.tapGesture()
            .when(.recognized)
            .bind {_ in
                self.steps.accept(PiCKStep.classroomMoveApplyRequired)
            }.disposed(by: disposeBag)
        
        outingApplyView.rx.tapGesture()
            .when(.recognized)
            .bind {_ in
                self.steps.accept(PiCKStep.outingApplyRequired)
            }.disposed(by: disposeBag)
        
        earlyLeaveApplyView.rx.tapGesture()
            .when(.recognized)
            .bind {_ in
                self.steps.accept(PiCKStep.earlyLeaveApplyRequired)
            }.disposed(by: disposeBag)
        
    }
    public override func addView() {
        [
            weekendMealApplyLabel,
            explanationLabel,
            weekendMealApplyView,
            additionApplyLabel,
            applyStackView
        ].forEach { view.addSubview($0) }
        
        [
            currnetMonthWeekendMealApplyLabel,
            applyButton,
            noApplyButton
        ].forEach { weekendMealApplyView.addSubview($0) }
        
        [
            classroomMoveApplyView,
            outingApplyView,
            earlyLeaveApplyView
        ].forEach { applyStackView.addArrangedSubview($0) }
    }
    public override func setLayout() {
        weekendMealApplyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.left.equalToSuperview().inset(24)
        }
        explanationLabel.snp.makeConstraints {
            $0.top.equalTo(weekendMealApplyLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().inset(24)
        }
        weekendMealApplyView.snp.makeConstraints {
            $0.top.equalTo(explanationLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
        currnetMonthWeekendMealApplyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        applyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(94)
            $0.height.equalTo(34)
            $0.width.equalTo(70)
        }
        noApplyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(applyButton.snp.right).offset(8)
            $0.height.equalTo(34)
            $0.width.equalTo(70)
        }
        additionApplyLabel.snp.makeConstraints {
            $0.top.equalTo(weekendMealApplyView.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(24)
        }
        applyStackView.snp.makeConstraints {
            $0.top.equalTo(additionApplyLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(120)
        }
    }
    
}
