import UIKit

import SnapKit
import Then

import Core
import DesignSystem

class FloorCell: BaseCollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            self.attribute()
        }
    }
    
    private var titleColor: UIColor {
        !isSelected ? .neutral50 : .white
    }
    private var bgColor: UIColor {
        !isSelected ? .primary1200 : .primary500
    }
    
    static let identifier = "floorCellID"
    
    public lazy var classroomLabel = UILabel().then {
        $0.font = .body2
    }
    
    override func attribute() {
        contentView.backgroundColor = bgColor
        contentView.layer.cornerRadius = 8
        
        classroomLabel.textColor = titleColor
    }
    override func layout() {
        contentView.addSubview(classroomLabel)
        
        classroomLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
}
