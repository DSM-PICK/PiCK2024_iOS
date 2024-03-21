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
    public var haveSchedule: Bool = false
    
    private var borderColor: UIColor {
        !isSelected ? .primary1200 : .secondary400
    }
    
    static let identifier = "academicScheduleCalendarCellID"
    
    private var dotView = UIView().then {
        $0.backgroundColor = .primary500
        $0.layer.cornerRadius = 2
        $0.isHidden = true
    }
    private var daysLabel = UILabel().then {
        $0.textColor = .neutral100
        $0.font = .buttonS
    }
    
    public func setup(
        day: String
    ) {
        self.daysLabel.text = day
    }
    
    public override func attribute() {
        contentView.backgroundColor = .primary1200
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = borderColor.cgColor
        self.isUserInteractionEnabled = false
        
        if haveSchedule == true {
            self.dotView.isHidden = false
        }
    }
    public override func layout() {
        [
            dotView,
            daysLabel
        ].forEach { contentView.addSubview($0) }
        
        dotView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(3)
            $0.width.height.equalTo(4)
        }
        daysLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    private func dateCheck() {
        self.contentView.backgroundColor = .primary500
        self.daysLabel.textColor = .white
    }
    
}
