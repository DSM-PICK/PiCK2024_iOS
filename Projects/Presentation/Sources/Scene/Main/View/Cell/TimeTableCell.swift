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
        $0.font = DesignSystemFontFamily.NotoSansKR.medium.font(size: 14)
    }
    public var timeLabel = UILabel().then {
        $0.text = "08:30 ~ 09:20"
        $0.textColor = .neutral500
        $0.font = .caption3
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        addView()
        setLayout()
    }
    
    private func setup() {
        contentView.backgroundColor = .neutral1000
        contentView.layer.cornerRadius = 4
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
            $0.left.equalToSuperview().inset(20)
        }
        periodImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(periodLabel.snp.right).offset(24)
        }
        subjectLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(periodImageView.snp.right).offset(24)
        }
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(subjectLabel.snp.right).offset(4)
        }
    }
    
}
