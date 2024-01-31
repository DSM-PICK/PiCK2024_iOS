import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class TimeTableView: UIView {
    
    private let date = Date()
    
    private let timeTableLabel = UILabel().then {
        $0.text = "시간표"
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
        $0.itemSize = .init(width: 302, height: 40)
        $0.minimumLineSpacing = 8
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(TimeTableCell.self, forCellWithReuseIdentifier: TimeTableCell.identifier)
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
            timeTableLabel,
            dateLabel,
            collectionView
        ].forEach { self.addSubview($0) }
    }
    private func setLayout() {
        timeTableLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalTo(timeTableLabel.snp.right).offset(8)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}

extension TimeTableView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeTableCell.identifier, for: indexPath) as? TimeTableCell
        else {
            return UICollectionViewCell()
        }
        cell.periodLabel.text = "\(indexPath.row)"
        return cell
    }
    
    
}
