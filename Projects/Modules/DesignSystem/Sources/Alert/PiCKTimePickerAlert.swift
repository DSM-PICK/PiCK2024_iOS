import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

public class PiCKTimePickerAlert: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private var clickToAction: ([String?]) -> Void
    
    private var hourIndex: String?
    private var minIndex: String?

    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    private let hourPicker = PiCKTimePickerView(pickerType: .hours)
    private let minPicker = PiCKTimePickerView(pickerType: .mins)
    private let hourPickerUpLine = UIView().then {
        $0.backgroundColor = .primary500
    }
    private let hourPickerUnderLine = UIView().then {
        $0.backgroundColor = .primary500
    }
    private let minPickerUpLine = UIView().then {
        $0.backgroundColor = .primary500
    }
    private let minPickerUnderLine = UIView().then {
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
    private lazy var pickerArray = [hourPicker, minPicker]

    public init(
        clickToAction: @escaping ([String?]) -> Void
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
                let hourIndex = String(
                    format: "%02d",
                    self?.hourPicker.hourText ?? 8
                )
                let minIndex = String(
                    format: "%02d",
                    self?.minPicker.selectedRow(inComponent: 0) ?? 0
                )
                self?.hourIndex = hourIndex
                self?.minIndex = minIndex
                self?.clickToAction([self?.hourIndex, self?.minIndex])
                self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
    private func layout() {
        view.addSubview(backgroundView)
        [
            hourPicker,
            minPicker,
            buttonStackView,
            colonLabel
        ].forEach { backgroundView.addSubview($0) }
        
        [
            hourPickerUpLine,
            hourPickerUnderLine
        ].forEach { hourPicker.addSubview($0) }
        
        [
            minPickerUpLine,
            minPickerUnderLine
        ].forEach { minPicker.addSubview($0) }
        
        
        [
            cancelButton,
            checkButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(330)
            $0.height.equalTo(229)
        }
        hourPicker.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.left.equalToSuperview().inset(42)
            $0.width.equalTo(90)
            $0.height.equalTo(150)
        }
        hourPickerUpLine.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(2)
        }
        hourPickerUnderLine.snp.makeConstraints {
            $0.top.equalTo(hourPickerUpLine.snp.bottom).offset(44)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(2)
        }
        minPicker.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.right.equalToSuperview().inset(42)
            $0.width.equalTo(90)
            $0.height.equalTo(150)
        }
        minPickerUpLine.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(2)
        }
        minPickerUnderLine.snp.makeConstraints {
            $0.top.equalTo(minPickerUpLine.snp.bottom).offset(44)
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
