import UIKit

import SnapKit
import Then

import Kingfisher
import SVGKit

import Core
import DesignSystem

public class TimeTableCell: BaseCollectionViewCell {
    
    static let identifier = "timeTableCellID"
    
    private var periodLabel = UILabel().then {
        $0.textColor = .primary50
        $0.font = .subTitle3B
    }
    private var subjectImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private var subjectLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private var timeLabel = UILabel().then {
        $0.textColor = .neutral300
        $0.font = .caption3
    }
    
    public func setup(
        period: Int,
        subjectImage: String,
        subjectName: String,
        time: String
    ) {
        self.periodLabel.text = "\(period)교시"
        self.subjectLabel.text = subjectName
        self.timeLabel.text = time
        self.subjectImageView.kf.setImage(with: URL(string: subjectImage))
    }
    
    public override func layout() {
        [
            periodLabel,
            subjectImageView,
            subjectLabel,
            timeLabel
        ].forEach { contentView.addSubview($0) }
        
        periodLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        subjectImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(periodLabel.snp.right).offset(24)
            $0.width.height.equalTo(32)
        }
        subjectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.left.equalTo(subjectImageView.snp.right).offset(24)
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(subjectLabel.snp.bottom)
            $0.left.equalTo(subjectImageView.snp.right).offset(24)
        }
    }

}
