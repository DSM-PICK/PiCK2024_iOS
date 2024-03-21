import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class TimeTableCollectionCell: BaseCollectionViewCell {
    
    static let identifier = "timeTableCollectionCellID"
    
    public var periodLabel = UILabel().then {
        $0.textColor = .primary50
        $0.font = .subTitle3B
    }
    public var periodImageView = UIImageView().then {
        $0.backgroundColor = .black
    }
    public var subjectLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .subTitle4M
    }
    
    public func setup(
        period: Int,
        subject: String
    ) {
        self.periodLabel.text = "\(period)"
        self.subjectLabel.text = subject
    }
    
    public override func attribute() {
        contentView.backgroundColor = .neutral1000
        contentView.layer.cornerRadius = 4
    }
    
    public override func layout() {
        [
            periodLabel,
            periodImageView,
            subjectLabel
        ].forEach { contentView.addSubview($0) }
        
        periodLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        }
        periodImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(54)
        }
        subjectLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(periodImageView.snp.right).offset(24)
        }
    }
    
}
