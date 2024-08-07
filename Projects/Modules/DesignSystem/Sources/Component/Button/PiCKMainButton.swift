import UIKit

import SnapKit
import Then

import Core

public class PiCKMainButton: BaseButton {
    
    public func getter(text: String) {
        label.text = text
    }
    
    private lazy var label = UILabel().then {
        $0.textColor = .primary50
        $0.font = .body3
    }
    
    public override func attribute() {
        self.backgroundColor = .white
        self.tintColor = .secondary500
        self.layer.cornerRadius = 20
    }
    
    public override func layout() {
        self.addSubview(label)
        
        self.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.snp.bottom).offset(5)
        }
        
    }

}
