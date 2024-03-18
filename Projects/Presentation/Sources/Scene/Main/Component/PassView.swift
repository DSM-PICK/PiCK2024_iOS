import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class PassView: BaseView, Stepper {
    
    public var steps = PublishRelay<Step>()
    
    public var clickToAction: () -> Void
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
    }
    private let topLabel = UILabel().then {
        $0.textColor = .neutral300
        $0.font = .caption2
        $0.numberOfLines = 0
    }
    
    var firstText = String()
    var secondText = String()

    private lazy var bottomLabel = UILabel().then {
        let attributedText = NSMutableAttributedString()
        
        let attributes1 = [
            NSAttributedString.Key.foregroundColor: UIColor.primary400,
            .font: UIFont.subTitle3M
        ]
        let text1 = NSAttributedString(string: firstText, attributes: attributes1)
        
        let attributes2 = [
            NSAttributedString.Key.foregroundColor: UIColor.neutral50,
            .font: UIFont.caption1
        ]
        let text2 = NSAttributedString(string: secondText, attributes: attributes2)
        
        attributedText.append(text1)
        attributedText.append(text2)
        
        $0.attributedText = attributedText
    }
    private let checkButton = UIButton(type: .system).then {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .buttonES
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .secondary500
    }
    
    public func setup(
        topLabel: String,
        bottomLabel: String,
        buttonTitle: String,
        firstPointText: String,
        secondPoinText: String
    ) {
        self.topLabel.text = topLabel
        self.bottomLabel.text = bottomLabel
        self.checkButton.setTitle(buttonTitle, for: .normal)
        self.firstText = firstPointText
        self.secondText = secondPoinText
    }
    
    init(
        clickToAction: @escaping () -> Void
    ) {
        self.clickToAction = clickToAction
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func attribute() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
    }
    public override func bind() {
        checkButton.rx.tap
            .bind { [weak self] in
                self?.clickToAction()
            }.disposed(by: disposeBag)
    }
    public override func addView() {
        [
            labelStackView,
            checkButton
        ].forEach { self.addSubview($0) }
        
        [
            topLabel,
            bottomLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
    }
    public override func setLayout() {
        labelStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(12)
        }
        checkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
    }
    
}
