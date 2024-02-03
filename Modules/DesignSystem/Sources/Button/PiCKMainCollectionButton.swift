import UIKit

import SnapKit
import Then

public class PiCKMainCollectionButton: UIButton {
    
    public override var isSelected: Bool {
        didSet {
            self.setup()
        }
    }
    
    private var titleColor: UIColor {
        !isSelected ? .primary400: .primary900
    }
    
    private var bgColor: UIColor {
        !isSelected ? .primary900: .primary100
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        layout()
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 14
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .buttonES
        self.backgroundColor = bgColor
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        self.tintColor = .clear
    }
    
    private func layout() {
        self.snp.makeConstraints {
            $0.height.equalTo(28)
        }
    }
}
