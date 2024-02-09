import UIKit

import SnapKit
import Then

public class PiCKMainButton: UIButton {
    
    private lazy var label = UILabel().then {
        $0.textColor = .primary50
        $0.font = .body3
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getter(text: String) {
        label.text = text
    }
    private func setup() {
        self.backgroundColor = .white
        self.tintColor = .secondary500
        self.layer.cornerRadius = 20
    }
    
    private func layout() {
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
