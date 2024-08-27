import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxGesture

import Core
import DesignSystem

public class EarlyLeaveApplyViewController: BaseViewController<EarlyLeaveApplyViewModel> {
    
    var depatureTimeText = BehaviorRelay<String>(value: "")
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "조기 귀가 신청"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let earlyLeaveApplyButton = PiCKNavigationApplyButton(type: .system)
    private let earlyLeaveTimeSelectLabel = UILabel().then {
        $0.text = "희망 귀가 시간을 선택해주세요"
        $0.textColor = .black
        $0.font = .body1
    }
    private let departureTimeLabel = PiCKPaddingLabel().then {
        $0.text = "출발 시간"
        $0.textColor = .neutral500
        $0.font = .caption2
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .neutral900
        $0.textAlignment = .left
    }
    private let earlyLeaveReasonLabel = UILabel().then {
        $0.text = "조기 귀가 사유를 적어주세요"
        $0.textColor = .black
        $0.font = .body1
    }
    private let earlyLeaveReasonTextView = PiCKApplyTextView()
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: earlyLeaveApplyButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    public override func bind() {
        let input = EarlyLeaveApplyViewModel.Input(
            reasonText: earlyLeaveReasonTextView.rx.text.orEmpty.asObservable(),
            startTimeText: depatureTimeText.asObservable(),
            earlyLeaveApplyButton: earlyLeaveApplyButton.rx.tap.asObservable()
        )
        let output =  viewModel.transform(input: input)
        
        output.isApplyButtonEnable.asObservable()
            .subscribe(
                onNext: { [self] status in
                    earlyLeaveApplyButton.isEnabled = status
                }
            )
            .disposed(by: disposeBag)
        
        departureTimeLabel.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                let modal = PiCKTimePickerAlert(clickToAction: { depatureTime in
                    self?.depatureTimeText.accept("\(depatureTime[0] ?? ""):\(depatureTime[1] ?? ""):00")
                    
                    self?.departureTimeLabel.text = "\(depatureTime[0] ?? ""):\(depatureTime[1] ?? "")"
                    self?.departureTimeLabel.textColor = .neutral50
                })
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self?.present(modal, animated: true)
            }.disposed(by: disposeBag)
    }
    public override func addView() {
        [
            earlyLeaveTimeSelectLabel,
            departureTimeLabel,
            earlyLeaveReasonLabel,
            earlyLeaveReasonTextView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        earlyLeaveTimeSelectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.left.equalToSuperview().inset(24)
        }
        departureTimeLabel.snp.makeConstraints {
            $0.top.equalTo(earlyLeaveTimeSelectLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        earlyLeaveReasonLabel.snp.makeConstraints {
            $0.top.equalTo(departureTimeLabel.snp.bottom).offset(40)
            $0.left.equalToSuperview().inset(24)
        }
        earlyLeaveReasonTextView.snp.makeConstraints {
            $0.top.equalTo(earlyLeaveReasonLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(120)
        }
    }
    
}
