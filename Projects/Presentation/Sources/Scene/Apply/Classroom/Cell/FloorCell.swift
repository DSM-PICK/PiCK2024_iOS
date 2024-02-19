import UIKit

import SnapKit
import Then

import Core
import DesignSystem

class FloorCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            self.setup()
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
        contentView.backgroundColor = bgColor
        contentView.layer.cornerRadius = 8
        
        classroomLabel.textColor = titleColor
    }
    private func layout() {
        contentView.addSubview(classroomLabel)
        
        classroomLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
}
