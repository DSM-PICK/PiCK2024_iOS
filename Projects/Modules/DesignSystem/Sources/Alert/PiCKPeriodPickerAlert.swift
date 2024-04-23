import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

public class PiCKPeriodPickerAlert: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private var clickToAction: ([Int?]) -> Void
    
    private var startPeriodIndex: String?
    private var endPeriodIndex: String?
    
    private var startPeriodText: Int?
    private var endPeriodText: Int?
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    private let startPeriodPicker = PiCKTimePickerView(pickerType: .period)
    private let endPeriodPicker = PiCKTimePickerView(pickerType: .period)
    private let startPeriodPickerUpLine = UIView().then {
        $0.backgroundColor = .primary500
    }
    private let startPeriodPickerUnderLine = UIView().then {
        $0.backgroundColor = .primary500
    }
    private let endPeriodPickerUpLine = UIView().then {
        $0.backgroundColor = .primary500
    }
    private let endPeriodPickerUnderLine = UIView().then {
        $0.backgroundColor = .primary500
    }
    private let colonLabel = UILabel().then {
        $0.text = ":"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 50)
    }
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.backgroundColor = .clear
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.neutral300, for: .normal)
        $0.titleLabel?.font = .buttonS
        $0.backgroundColor = .neutral700
        $0.layer.cornerRadius = 4
    }
    private let checkButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .buttonS
        $0.backgroundColor = .primary600
        $0.layer.cornerRadius = 4
    }
    private lazy var pickerArray = [startPeriodPicker, endPeriodPicker]

    public init(
        clickToAction: @escaping ([Int?]) -> Void
    ) {
        self.clickToAction = clickToAction
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .placeholderText
        bind()
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
        pickerArray.forEach { $0.subviews[1].backgroundColor = .clear }
    }
    private func bind() {
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
        
        checkButton.rx.tap
            .bind { [weak self] in
                let startPeriod = self?.startPeriodPicker.selectedRow(inComponent: 0) ?? 0
                let endPeriod = self?.endPeriodPicker.selectedRow(inComponent: 0) ?? 0
                
                self?.clickToAction([startPeriod + 1, endPeriod + 1])
                self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
    private func layout() {
        view.addSubview(backgroundView)
        [
            startPeriodPicker,
            endPeriodPicker,
            buttonStackView,
            colonLabel
        ].forEach { backgroundView.addSubview($0) }
        
        [
            startPeriodPickerUpLine,
            startPeriodPickerUnderLine
        ].forEach { startPeriodPicker.addSubview($0) }
        
        [
            endPeriodPickerUpLine,
            endPeriodPickerUnderLine
        ].forEach { endPeriodPicker.addSubview($0) }
        
        
        [
            cancelButton,
            checkButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(330)
            $0.height.equalTo(229)
        }
        startPeriodPicker.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.left.equalToSuperview().inset(42)
            $0.width.equalTo(90)
            $0.height.equalTo(150)
        }
        startPeriodPickerUpLine.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(2)
        }
        startPeriodPickerUnderLine.snp.makeConstraints {
            $0.top.equalTo(startPeriodPickerUpLine.snp.bottom).offset(44)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(2)
        }
        endPeriodPicker.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.right.equalToSuperview().inset(42)
            $0.width.equalTo(90)
            $0.height.equalTo(150)
        }
        endPeriodPickerUpLine.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(2)
        }
        endPeriodPickerUnderLine.snp.makeConstraints {
            $0.top.equalTo(endPeriodPickerUpLine.snp.bottom).offset(44)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(2)
        }
        colonLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(60)
        }
        buttonStackView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
    }

}
