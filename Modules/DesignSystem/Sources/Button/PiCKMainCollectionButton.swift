import UIKit

import SnapKit
import Then

public class PiCKFloorButton: UIButton {
    
    public override var isSelected: Bool {
        didSet {
            self.setup()
        }
    }
    
    private var titleColor: UIColor {
        !isSelected ? .neutral50: .white
    }
    
    private var bgColor: UIColor {
        !isSelected ? .primary1200: .primary500
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        layout()
    }
    
    private func setup() {
//        self.backgroundColor = .white
        self.layer.cornerRadius = 17
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .body2
        self.backgroundColor = bgColor
        self.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        self.tintColor = .clear
    }
    
    private func layout() {
        self.snp.makeConstraints {
            $0.height.equalTo(34)
        }
    }
}
