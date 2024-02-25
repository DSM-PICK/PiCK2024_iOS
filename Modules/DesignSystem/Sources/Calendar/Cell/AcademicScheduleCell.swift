import UIKit

import SnapKit
import Then

import Core

public class AcademicScheduleCalendarCell: BaseCollectionViewCell {
    
    public override var isSelected: Bool {
        didSet {
            self.attribute()
        }
    }
    public var isToday: Bool = false
    
    private var borderColor: UIColor {
        !isSelected ? .primary1200 : .secondary400
    }
    
    static let identifier = "academicScheduleCalendarCellID"
    
    public let daysLabel = UILabel().then {
        $0.textColor = .neutral100
        $0.font = .buttonS
    }
    
    public override func attribute() {
        contentView.backgroundColor = .primary1200
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = borderColor.cgColor
        self.isUserInteractionEnabled = false
    }
    public override func layout() {
        contentView.addSubview(daysLabel)
        
        daysLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    private func dateCheck() {
        self.contentView.backgroundColor = .primary500
        self.daysLabel.textColor = .white
    }
    
}
