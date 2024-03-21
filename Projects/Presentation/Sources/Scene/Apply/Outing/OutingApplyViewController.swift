import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxGesture

import Core
import DesignSystem

public class OutingApplyViewController: BaseViewController<OutingApplyViewModel> {
    
    var depatureTimeText = BehaviorRelay<String>(value: "")
    var arrivalTimeText = BehaviorRelay<String>(value: "")
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "외출 신청"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private let outingApplyButton = PiCKNavigationApplyButton(type: .system)
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
    private let departureTimeLabel = PiCKPaddingLabel().then {
        $0.text = "출발 시간"
        $0.textColor = .neutral500
        $0.font = .caption2
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .neutral900
        $0.textAlignment = .left
    }
    private let slashLabel = UILabel().then {
        $0.text = "~"
        $0.textColor = .neutral50
        $0.font = .subTitle1M
        $0.textAlignment = .center
    }
    private let arrivalTimeLabel = PiCKPaddingLabel().then {
        $0.text = "도착 시간"
        $0.textColor = .neutral500
        $0.font = .caption2
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .neutral900
        $0.textAlignment = .left
    }
    private let outingReasonLabel = UILabel().then {
        $0.text = "외출 사유를 적어주세요"
        $0.textColor = .black
        $0.font = .body1
    }
    private let outingReasonTextView = PiCKApplyTextView()
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: outingApplyButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    public override func bind() {
        let input = OutingApplyViewModel.Input(
            reasonText: outingReasonTextView.rx.text.orEmpty.asObservable(),
            startTimeText: depatureTimeText.asObservable(),
            endTimeText: arrivalTimeText.asObservable(),
            outingApplyButton: outingApplyButton.rx.tap.asObservable()
        )
        let output =  viewModel.transform(input: input)
        
        output.isApplyButtonEnable.asObservable()
            .subscribe(
                onNext: { [self] status in
                    outingApplyButton.isEnabled = status
                }
            )
            .disposed(by: disposeBag)
        
        departureTimeLabel.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                let modal = PiCKTimePickerAlert(clickToAction: { depatureTime in
                    self?.depatureTimeText.accept(
                        "\(depatureTime[0] ?? ""):\(depatureTime[1] ?? "")"
                    )
                    
                    self?.departureTimeLabel.text = "\(depatureTime[0] ?? "") : \(depatureTime[1] ?? "")"
                    self?.departureTimeLabel.textColor = .neutral50
                })
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self?.present(modal, animated: true)
            }.disposed(by: disposeBag)
        
        arrivalTimeLabel.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                let modal = PiCKTimePickerAlert(clickToAction: { arrialTime in
                    self?.arrivalTimeText.accept("\(arrialTime[0] ?? ""):\(arrialTime[1] ?? "")")
                    
                    self?.arrivalTimeLabel.text = "\(arrialTime[0] ?? "") : \(arrialTime[1] ?? "")"
                    self?.arrivalTimeLabel.textColor = .neutral50
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
            departureTimeLabel,
            slashLabel,
            arrivalTimeLabel
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
            $0.top.equalTo(outingTimeStackView.snp.bottom).offset(40)
            $0.left.equalToSuperview().inset(24)
        }
        outingReasonTextView.snp.makeConstraints {
            $0.top.equalTo(outingReasonLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(120)
        }
    }
    
}
