import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

public class PiCKTextField: UITextField {
    
    private let disposeBag = DisposeBag()
    
    public var isSecurity: Bool = false {
        didSet {
            textHideButton.isHidden = !isSecurity
            self.isSecureTextEntry = true
            self.addLeftAndRightView()
        }
    }
    
    private let textHideButton = UIButton(type: .system).then {
        $0.setImage(.eyeOff, for: .normal)
        $0.tintColor = .neutral50
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true  
    }
    
    public init() {
        super.init(frame: .zero)
        setup()
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(textHideButton)
    
        textHideButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
        setPlaceholder()
    }
    
    private func setup() {
        self.textColor = .neutral50
        self.font = .caption1
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
        self.tintColor = .primary500
        self.addLeftView()
        self.addRightView()
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.keyboardType = .alphabet
    }

    private func bind() {
        self.rx.text.orEmpty
            .map { $0.isEmpty ? UIColor.clear.cgColor : UIColor.secondary500.cgColor }
            .subscribe(onNext: { [weak self] borderColor in
                self?.layer.borderColor = borderColor
            }).disposed(by: disposeBag)
        
        self.rx.text.orEmpty
            .map { $0.isEmpty ? UIColor.neutral900 : UIColor.white }
            .subscribe(onNext: { [weak self] backgroundColor in
                self?.backgroundColor = backgroundColor
            }).disposed(by: disposeBag)
        
        self.textHideButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.isSecureTextEntry.toggle()
            let imageName: UIImage = (self?.isSecureTextEntry ?? false) ? .eyeOff: .eyeOn
            self?.textHideButton.setImage(imageName, for:.normal)
        }).disposed(by: disposeBag)

    }

    private func setPlaceholder() {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(
            string: string,
            attributes: [
                .foregroundColor: UIColor.neutral500,
                .font: UIFont.caption2
            ]
        )
    }

}
