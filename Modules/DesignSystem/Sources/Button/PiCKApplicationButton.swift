import UIKit

import RxSwift
import RxCocoa

public class PiCKApplicationButton: UIButton {
    
    private let disposeBag = DisposeBag()

    public override var isSelected: Bool {
        didSet {
            self.setup()
        }
    }
    
    private var titleColor: UIColor {
        !isSelected ? .neutral50: .white
    }
    
    private var bgColor: UIColor {
        !isSelected ? .white: .primary500
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .buttonES
        self.backgroundColor = bgColor
        self.tintColor = .clear
    }
    private func bind() {
        self.rx.tap
            .bind {
                self.isSelected.toggle()
            }.disposed(by: disposeBag)
    }
    
}
