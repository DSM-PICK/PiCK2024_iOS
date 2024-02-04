import UIKit

import SnapKit
import Then

import DesignSystem

public class TimeTableCell: UICollectionViewCell {
    
    static let identifier = "timeTableCellID"
    
    public var periodLabel = UILabel().then {
        $0.textColor = .primary50
        $0.font = .subTitle3B
    }
    public var periodImageView = UIImageView().then {
        $0.backgroundColor = .black
    }
    public var subjectLabel = UILabel().then {
        $0.text = "창체"
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    public var timeLabel = UILabel().then {
        $0.text = "08:30 ~ 09:20"
        $0.textColor = .neutral500
        $0.font = .caption3
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        addView()
        setLayout()
    }
    
    private func addView() {
        [
            periodLabel,
            periodImageView,
            subjectLabel,
            timeLabel
        ].forEach { contentView.addSubview($0) }
    }
    private func setLayout() {
        periodLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
        }
        periodImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(74)
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
