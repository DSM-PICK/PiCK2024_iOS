import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class TimeTableCell: BaseCollectionViewCell {
    
    static let identifier = "timeTableCellID"
    
    private var periodLabel = UILabel().then {
        $0.textColor = .primary50
        $0.font = .subTitle3B
    }
    private var periodImageView = UIImageView().then {
        $0.backgroundColor = .black
    }
    private var subjectLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private var timeLabel = UILabel().then {
        $0.textColor = .neutral500
        $0.font = .caption3
    }
    
    public func setup(
        period: Int,
        subject: String
    ) {
        self.periodLabel.text = "\(period)"
        self.subjectLabel.text = subject
    }
    
    public override func layout() {
        [
            periodLabel,
            periodImageView,
            subjectLabel,
            timeLabel
        ].forEach { contentView.addSubview($0) }
        
        periodLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()//.inset(10)
        }
        periodImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(64)
            $0.width.height.equalTo(32)
        }
        subjectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.left.equalTo(periodImageView.snp.right).offset(24)
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(subjectLabel.snp.bottom)
            $0.left.equalTo(periodImageView.snp.right).offset(24)
        }
    }
    
}
