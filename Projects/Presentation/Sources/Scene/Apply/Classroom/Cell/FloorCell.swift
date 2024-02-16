import UIKit

import SnapKit
import Then

import Core
import DesignSystem

class FloorCell: UICollectionViewCell {
    
    static let identifier = "floorCellID"
    
    public let classroomLabel = UILabel().then {
        $0.textColor = .neutral50
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
        contentView.backgroundColor = .primary1200
        contentView.layer.cornerRadius = 8
    }
    private func layout() {
        contentView.addSubview(classroomLabel)
        
        classroomLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
}
