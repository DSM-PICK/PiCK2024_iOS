import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class TimeTableCollectionView: UIView {
    
    private let date = Date()
    private lazy var todayDate = date.toString(DateFormatIndicated.dateAndDays.rawValue)
    
    private let timeTableLabel = UILabel().then {
        $0.text = "시간표"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var dateLabel = UILabel().then {
        $0.text = "\(todayDate)"
        $0.textColor = .neutral300
        $0.font = .body3
    }
    private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.frame.width - 40, height: 40)
        $0.minimumLineSpacing = 8
    }
    private lazy var timetableCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.register(TimeTableCollectionCell.self, forCellWithReuseIdentifier: TimeTableCollectionCell.identifier)
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
        timetableCollectionView.delegate = self
        timetableCollectionView.dataSource = self
    }
    private func addView() {
        [
            timeTableLabel,
            dateLabel,
            timetableCollectionView
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
        timetableCollectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}

extension TimeTableCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeTableCollectionCell.identifier, for: indexPath) as? TimeTableCollectionCell
        else {
            return UICollectionViewCell()
        }
        cell.periodLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    
    
}
