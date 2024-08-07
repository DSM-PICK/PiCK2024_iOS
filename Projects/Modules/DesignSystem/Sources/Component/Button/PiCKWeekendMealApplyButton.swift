import UIKit

import Core

public class PiCKWeekendMealApplyButton: BaseButton {

    public override var isSelected: Bool {
        didSet {
            self.attribute()
        }
    }
    
    private var titleColor: UIColor {
        !isSelected ? .neutral50: .white
    }
    
    private var bgColor: UIColor {
        !isSelected ? .white: .primary500
    }
    
    public override func attribute() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .buttonES
        self.backgroundColor = bgColor
        self.tintColor = .clear
    }
    
}
