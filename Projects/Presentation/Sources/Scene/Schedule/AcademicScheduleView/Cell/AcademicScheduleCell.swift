import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class AcademicScheduleCell: BaseCollectionViewCell {
    
    static let identifier = "academicScheduleCellID"
    
    private let lineView = UIView().then {
        $0.backgroundColor = .secondary500
        $0.layer.cornerRadius = 1.5
    }
    public let dateLabel = UILabel().then {
        $0.text = "1"
        $0.textColor = .neutral50
        $0.font = .subTitle2M
    }
    public let dayLabel = UILabel().then {
        $0.text = "월요일"
        $0.textColor = .neutral300
        $0.font = .body3
    }
    public let scheduleLabel = UILabel().then {
        $0.text = "신정"
        $0.textColor = .neutral50
        $0.font = .subTitle2M
    }
    
    public override func attribute() {
        contentView.backgroundColor = .primary1200
        contentView.layer.cornerRadius = 4
    }
    public override func layout() {
        [
            lineView,
            dateLabel,
            dayLabel,
            scheduleLabel
        ].forEach { contentView.addSubview($0) }
        
        lineView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalTo(3)
        }
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(lineView.snp.right).offset(20)
        }
        dayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(dateLabel.snp.right).offset(12)
        }
        scheduleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(40)
        }
    }
    
}
