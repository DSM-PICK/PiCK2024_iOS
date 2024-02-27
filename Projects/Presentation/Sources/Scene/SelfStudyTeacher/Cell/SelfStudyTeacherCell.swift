import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class SelfStudyTeacherCell: BaseCollectionViewCell {
    
    static let identifier = "selfStudyTeacherCellID"
    
    private let floorStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
    }
    private let firstFloorLabel = UILabel().then {
        $0.text = "1층"
        $0.textColor = .neutral100
        $0.font = .body1
    }
    private let secondFloorLabel = UILabel().then {
        $0.text = "3층"
        $0.textColor = .neutral100
        $0.font = .body1
    }
    private let thirdFloorLabel = UILabel().then {
        $0.text = "3층"
        $0.textColor = .neutral100
        $0.font = .body1
    }
    private let teacherStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
    }
    private let firstFloorTeacherLabel = UILabel().then {
        $0.text = "조영준 선생님"
        $0.textColor = .neutral50
        $0.font = .label1
    }
    private let secondFloorTeacherLabel = UILabel().then {
        $0.text = "조영준 선생님"
        $0.textColor = .neutral50
        $0.font = .label1
    }
    private let thirdFloorTeachercLabel = UILabel().then {
        $0.text = "조영준 선생님"
        $0.textColor = .neutral50
        $0.font = .label1
    }
    
    public override func attribute() {
        contentView.backgroundColor = .primary1000
        contentView.layer.cornerRadius = 4
        
    }
    public override func layout() {
        [
            floorStackView,
            teacherStackView
        ].forEach { contentView.addSubview($0) }
        
        [
            firstFloorLabel,
            secondFloorLabel,
            thirdFloorLabel
        ].forEach { floorStackView.addArrangedSubview($0) }
        
        [
            firstFloorTeacherLabel,
            secondFloorTeacherLabel,
            thirdFloorTeachercLabel
        ].forEach { teacherStackView.addArrangedSubview($0) }
        
        floorStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        }
        teacherStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(floorStackView.snp.right).offset(28)
        }
    }

}
