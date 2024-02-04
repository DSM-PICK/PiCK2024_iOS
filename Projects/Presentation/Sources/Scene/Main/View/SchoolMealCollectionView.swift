import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class SchoolMealCollectionView: UIView {
    
    private let date = Date()
    
    private let schoolMealLabel = UILabel().then {
        $0.text = "급식"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var dateLabel = UILabel().then {
        $0.text = "\(date.toString(DateFormatIndicated.dateAndDays.rawValue))"
        $0.textColor = .neutral300
        $0.font = .body3
    }
    private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.frame.width - 32, height: 225)
        $0.minimumLineSpacing = 20
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(SchoolMealCell.self, forCellWithReuseIdentifier: SchoolMealCell.identifier)
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
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func addView() {
        [
            schoolMealLabel,
            dateLabel,
            collectionView
        ].forEach { self.addSubview($0) }
    }
    private func setLayout() {
        schoolMealLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalTo(schoolMealLabel.snp.right).offset(8)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}
extension SchoolMealCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchoolMealCell.identifier, for: indexPath) as? SchoolMealCell
        else {
            return UICollectionViewCell()
        }
        switch indexPath.row {
            case 0:
                cell.schoolMealTimeLabel.text = "조식"
                return cell
            case 1:
                cell.schoolMealTimeLabel.text = "중식"
                return cell
            case 2:
                cell.schoolMealTimeLabel.text = "석식"
                return cell
            default:
                return cell
        }
    }
    
    
}
