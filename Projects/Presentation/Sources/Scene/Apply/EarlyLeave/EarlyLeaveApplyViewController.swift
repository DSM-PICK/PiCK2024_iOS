import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import DesignSystem

public class EarlyLeaveApplyViewController: BaseVC<EarlyLeaveApplyViewModel> {
    
    private let disposeBag = DisposeBag()
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "조기 귀가 신청"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let earlyLeaveApplyButton = PiCKApplyButton(type: .system)
    private let earlyLeaveTimeSelectLabel = UILabel().then {
        $0.text = "희망 귀가 시간을 선택해주세요"
        $0.textColor = .black
        $0.font = .body1
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
    private let earlyLeaveReasonLabel = UILabel().then {
        $0.text = "조기 귀가 사유를 적어주세요"
        $0.textColor = .black
        $0.font = .body1
    }
    private let earlyLeaveReasonTextView = PiCKApplyTextView()
    
    public override func attribute() {
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: earlyLeaveApplyButton)
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
    }
    public override func addView() {
        [
            earlyLeaveTimeSelectLabel,
            departureTimeButton,
            earlyLeaveReasonLabel,
            earlyLeaveReasonTextView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        earlyLeaveTimeSelectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.left.equalToSuperview().inset(24)
        }
        departureTimeButton.snp.makeConstraints {
            $0.top.equalTo(earlyLeaveTimeSelectLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        earlyLeaveReasonLabel.snp.makeConstraints {
            $0.top.equalTo(departureTimeButton.snp.bottom).offset(40)
            $0.left.equalToSuperview().inset(24)
        }
        earlyLeaveReasonTextView.snp.makeConstraints {
            $0.top.equalTo(earlyLeaveReasonLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(120)
        }
    }
    
}
