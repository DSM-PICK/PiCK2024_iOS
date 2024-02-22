import UIKit

import SnapKit
import Then

class SchoolMealCalendarCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            self.setup()
        }
    }
    
    private var bgColor: UIColor {
        !isSelected ? .primary500 : .white
    }
    private var borderColor: UIColor {
        !isSelected ? .white : .primary500
    }
    
    static let identifier = "calendarCellID"
    
    public let daysLabel = UILabel().then {
        $0.textColor = .neutral100
        $0.font = .buttonES
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = borderColor.cgColor
    }
    private func layout() {
        contentView.addSubview(daysLabel)
        
        daysLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
