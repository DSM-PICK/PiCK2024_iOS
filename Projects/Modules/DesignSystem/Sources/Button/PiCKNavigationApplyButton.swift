import UIKit

import Core

public class PiCKNavigationApplyButton: BaseButton {

    public override var isEnabled: Bool {
        didSet {
            self.layout()
        }
    }
    
    private var titleColor: UIColor {
        !isEnabled ? .neutral500: .neutral50
    }
    public override func attribute() {
        self.setTitle("확인", for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .subTitle3M
    }
    
}
