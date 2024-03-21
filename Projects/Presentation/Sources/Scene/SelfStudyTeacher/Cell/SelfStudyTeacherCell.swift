import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class SelfStudyTeacherCell: BaseCollectionViewCell {
    
    static let identifier = "selfStudyTeacherCellID"
    
    private let floorLabel = UILabel().then {
        $0.textColor = .neutral100
        $0.font = .body1
    }
    private let teacherLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .label1
    }
    public func setup(
        flooor: Int,
        teacher: String
    ) {
        self.floorLabel.text = "\(flooor)층"
        self.teacherLabel.text = "\(teacher) 선생님"
    }
    
    public override func attribute() {
        contentView.backgroundColor = .primary1000
        contentView.layer.cornerRadius = 4
    }
    public override func layout() {
        [
            floorLabel,
            teacherLabel
        ].forEach { contentView.addSubview($0) }
        
        floorLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        }
        teacherLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(floorLabel.snp.right).offset(28)
        }
    }

}
