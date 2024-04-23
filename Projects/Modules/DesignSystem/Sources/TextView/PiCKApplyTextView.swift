import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

public class PiCKApplyTextView: UITextView {
    
    private let disposeBag = DisposeBag()
    
    private let placeholderLabel = UILabel().then {
        $0.text = "내용을 입력해주세요"
        $0.textColor = .neutral500
        $0.font = .caption2
        $0.isHidden = false
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
        bind()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.rx.didBeginEditing
            .bind { [weak self] in
                self?.placeholderLabel.isHidden = true
            }.disposed(by: disposeBag)
        
        self.rx.didEndEditing
            .bind { [weak self] in
                if self?.text.isEmpty == true {
                    self?.placeholderLabel.isHidden = false
                }
            }.disposed(by: disposeBag)
    }
    private func setup() {
        self.textColor = .neutral50
        self.font = .caption2
        self.textContainer.maximumNumberOfLines = 0
        self.backgroundColor = .neutral900
        self.layer.cornerRadius = 4
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 16, right: 16)
    }
    private func layout() {
        self.addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
    }
    
}
