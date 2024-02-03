import UIKit

import SnapKit
import Then

import DesignSystem

public class SchoolMealCell: UICollectionViewCell {
    
    static let identifier = "schoolMealCellID"
    
    public lazy var schoolMealTimeLabel = UILabel().then {
        $0.textColor = .primary200
        $0.font = .subTitle2B
    }
    public lazy var menuLabel = UILabel().then {
        $0.text = "녹두찰밥\n스팸구이\n시리얼(블루베리)\n우유\n한우궁중떡볶이\n미니고구마파이"
        $0.textColor = .neutral50
        $0.font = .body1
        $0.numberOfLines = 0
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
        contentView.backgroundColor = .primary1000
        contentView.layer.cornerRadius = 4
        
    }
    private func addView() {
        [
            schoolMealTimeLabel,
            menuLabel
        ].forEach { contentView.addSubview($0) }
    }
    private func setLayout() {
        schoolMealTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(28)
        }
        menuLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(38)
        }
    }

}
