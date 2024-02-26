import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

public class PiCKApplyTextView: UITextView {
    
    private let disposeBag = DisposeBag()
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.rx.text.orEmpty
            .bind { [weak self] text in
                if text == "내용을 입력해주세요" {
                    self?.textColor = .neutral500
                } else {
                    self?.textColor = .neutral50
                }
            }.disposed(by: disposeBag)
        
        self.rx.didBeginEditing
            .bind { [weak self] in
                if self?.text == "내용을 입력해주세요" {
                    self?.text = ""
                }
            }.disposed(by: disposeBag)
        
        self.rx.didEndEditing
            .bind { [weak self] in
                if self?.text.isEmpty == true {
                    self?.text = "내용을 입력해주세요"
                }
            }.disposed(by: disposeBag)
    }
    private func setup() {
        self.text = "내용을 입력해주세요"
        self.textColor = .neutral50
        self.font = .caption2
        self.textContainer.maximumNumberOfLines = 0
        self.backgroundColor = .neutral900
        self.layer.cornerRadius = 4
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 16, right: 16)
    }
    
}
