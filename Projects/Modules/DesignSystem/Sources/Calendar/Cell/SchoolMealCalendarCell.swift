import UIKit

import SnapKit
import Then

import Core

public class SchoolCalendarCell: BaseCollectionViewCell {
    
    public override var isSelected: Bool {
        didSet {
            self.attribute()
        }
    }
    
    private var bgColor: UIColor {
        !isSelected ? .primary500 : .white
    }
    private var borderColor: UIColor {
        !isSelected ? .white : .primary500
    }
    
    static let identifier = "calendarCellID"
    
    public lazy var daysLabel = UILabel().then {
        $0.textColor = .neutral100
        $0.font = .buttonES
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.attribute()
        self.layout()
        self.daysLabel.textColor = .neutral100
    }
    
    public override func attribute() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = borderColor.cgColor
    }
    public override func layout() {
        contentView.addSubview(daysLabel)
        
        daysLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    public func todaySetting() {
        self.contentView.backgroundColor = .primary500
        self.backgroundColor = .clear
        self.daysLabel.textColor = .white
        self.contentView.layer.borderColor = UIColor.primary500.cgColor
    }
    
}
