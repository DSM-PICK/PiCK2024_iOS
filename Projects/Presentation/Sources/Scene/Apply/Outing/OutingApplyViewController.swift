import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import DesignSystem

public class OutingApplyViewController: BaseVC<OutingApplyViewModel> {
    
    private let disposeBag = DisposeBag()
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "외출 신청"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let outingApplyButton = PiCKApplyButton(type: .system)
    private let outingTimeSelectLabel = UILabel().then {
        $0.text = "희망 외출 시간을 선택해주세요"
        $0.textColor = .black
        $0.font = .body1
    }
    private let outingTimeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.backgroundColor = .clear
        $0.alignment = .fill
        $0.distribution = .fillProportionally
    }
    private let departureTimeButton = UIButton(type: .system).then {
        $0.setTitle("출발 시간", for: .normal)
        $0.setTitleColor(.neutral500, for: .normal)
        $0.titleLabel?.font = .caption2
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .neutral900
        $0.contentHorizontalAlignment = .left
        $0.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
    }
    private let slashLabel = UILabel().then {
        $0.text = "~"
        $0.textColor = .neutral50
        $0.font = .subTitle1M
        $0.textAlignment = .center
    }
    private let arrivalTimeButton = UIButton(type: .system).then {
        $0.setTitle("도착 시간", for: .normal)
        $0.setTitleColor(.neutral500, for: .normal)
        $0.titleLabel?.font = .caption2
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .neutral900
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
    }
    private let outingReasonLabel = UILabel().then {
        $0.text = "외출 사유를 적어주세요"
        $0.textColor = .black
        $0.font = .body1
    }
    private let outingReasonTextView = PiCKApplyTextView()
    
    public override func attribute() {
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: outingApplyButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    public override func bind() {
        departureTimeButton.rx.tap
            .bind { [weak self] in
                let modal = PiCKTimePickerAlert(clickToAction: { depatureTime in
                    self?.departureTimeButton.setTitle("\(depatureTime[0] ?? "") : \(depatureTime[1] ?? "")", for: .normal)
                    self?.departureTimeButton.setTitleColor(.neutral50, for: .normal)
                })
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self?.present(modal, animated: true)
            }.disposed(by: disposeBag)
        
        arrivalTimeButton.rx.tap
            .bind { [weak self] in
                let modal = PiCKTimePickerAlert(clickToAction: { arrialTime in
                    self?.arrivalTimeButton.setTitle("\(arrialTime[0] ?? "") : \(arrialTime[1] ?? "")", for: .normal)
                    self?.arrivalTimeButton.setTitleColor(.neutral50, for: .normal)
                })
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self?.present(modal, animated: true)
            }.disposed(by: disposeBag)
    }
    public override func addView() {
        [
            outingTimeSelectLabel,
            outingTimeStackView,
            outingReasonLabel,
            outingReasonTextView
        ].forEach { view.addSubview($0) }
        
        [
            departureTimeButton,
            slashLabel,
            arrivalTimeButton
        ].forEach { outingTimeStackView.addArrangedSubview($0) }
    }
    public override func setLayout() {
        outingTimeSelectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.left.equalToSuperview().inset(24)
        }
        outingTimeStackView.snp.makeConstraints {
            $0.top.equalTo(outingTimeSelectLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        outingReasonLabel.snp.makeConstraints {
            $0.top.equalTo(departureTimeButton.snp.bottom).offset(40)
            $0.left.equalToSuperview().inset(24)
        }
        outingReasonTextView.snp.makeConstraints {
            $0.top.equalTo(outingReasonLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(120)
        }
    }
    
}
