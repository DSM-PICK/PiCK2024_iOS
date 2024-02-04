import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class TimeTableView: UIView {
    
    private let dateLabel = UILabel().then {
        $0.text = "2월 4일 (일)"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var collectionviewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 12
        $0.itemSize = .init(width: self.frame.width - 46, height: 52)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionviewLayout
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
            dateLabel,
            collectionView
        ].forEach { self.addSubview($0) }
    }
    private func setLayout() {
        dateLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(7)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(25)
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
        cell.periodLabel.text = "\(indexPath.row + 1)교시"
        return cell
    }
    
}
