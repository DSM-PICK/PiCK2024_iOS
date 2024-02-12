import UIKit

public class PiCKApplyButton: UIButton {

    public override var isEnabled: Bool {
        didSet {
            self.setup()
        }
    }
    
    private var titleColor: UIColor {
        !isEnabled ? .neutral500: .neutral50
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        self.setTitle("확인", for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .subTitle3M
    }
    
}
