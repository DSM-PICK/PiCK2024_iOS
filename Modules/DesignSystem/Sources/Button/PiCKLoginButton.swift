import UIKit

import Core

public class PiCKLoginButton: BaseButton {
    
    public override var isEnabled: Bool {
        didSet {
            self.layout()
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                let normalColor = self.bgColor
                let highlightedColor = UIColor.primary800
                self.backgroundColor = self.isHighlighted ? highlightedColor : normalColor
            })
        }
    }
    
    private var titleColor: UIColor {
        !isEnabled ? .neutral300: .white
    }
    
    private var bgColor: UIColor {
        !isEnabled ? .primary1000: .primary400
    }
    
    public override func layout() {
        self.layer.cornerRadius = 4
        self.setTitle("로그인", for: .normal)
        self.titleLabel?.font = .buttonS
        self.backgroundColor = bgColor
        self.setTitleColor(titleColor, for: .normal)
    }
    
}
