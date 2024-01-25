import UIKit

public class PiCKLoginButton: UIButton {
    
    public override var isEnabled: Bool {
        didSet {
            self.setup()
        }
    }
    private var fgColor: UIColor {
        !isEnabled ? .neutral300: .white
    }
    
    private var bgColor: UIColor {
        !isEnabled ? .primary1000: .primary400
    }
    
    private func setup() {
        self.layer.cornerRadius = 4
        self.setTitle("로그인", for: .normal)
        self.titleLabel?.font = .buttonS
        self.backgroundColor = bgColor
        self.setTitleColor(fgColor, for: .normal)
    }
    
}
