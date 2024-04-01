import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class TimeTableCollectionCell: BaseCollectionViewCell {
    
    static let identifier = "timeTableCollectionCellID"
    
    private var periodLabel = UILabel().then {
        $0.textColor = .primary50
        $0.font = .subTitle3B
    }
    private var subjectImageView = UIImageView()
    private var subjectLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .subTitle4M
    }
    private var subjectTimeLabel = UILabel().then {
        $0.textColor = .neutral500
        $0.font = .caption3
    }
    
    public func setup(
        period: Int,
        subjectImage: UIImage,
        subject: String,
        subjectTime: String
    ) {
        self.periodLabel.text = "\(period)"
        self.subjectImageView.image = subjectImage
        self.subjectLabel.text = subject
        self.subjectTimeLabel.text = subjectTime
    }
    
    public override func attribute() {
        contentView.backgroundColor = .neutral1000
        contentView.layer.cornerRadius = 4
    }
    
    public override func layout() {
        [
            periodLabel,
            subjectImageView,
            subjectLabel,
            subjectTimeLabel
        ].forEach { contentView.addSubview($0) }
        
        periodLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        }
        subjectImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(54)
            $0.width.height.equalTo(24)
        }
        subjectLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(subjectImageView.snp.right).offset(24)
        }
        subjectTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(subjectLabel.snp.right).offset(4)
        }
    }
    
}
