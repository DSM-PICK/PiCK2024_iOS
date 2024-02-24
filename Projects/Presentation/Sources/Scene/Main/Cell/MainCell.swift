import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class MainCell: BaseCollectionViewCell {
    
    var mainCellIndex: Int = 0
    private let date = Date()
    private lazy var todayDate = date.toString(DateFormatIndicated.dateAndDays.rawValue)
    private let mealTimeArray: [String] = ["조식", "중식", "석식"]
    
    static let identifier = "mainCellID"
    
    private let titleLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var dateLabel = UILabel().then {
        $0.text = todayDate
        $0.textColor = .neutral300
        $0.font = .body3
    }
    public let moreButton = UIButton(type: .system).then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.neutral200, for: .normal)
        $0.titleLabel?.font = .body3
        //        $0.setImage(.chevronRightIcon, for: .normal)
        //        $0.imageEdgeInsets = .init(
        //            top: 5,
        //            left: 12,
        //            bottom: 5,
        //            right: 8)
        //        $0.tintColor = .neutral200
        $0.semanticContentAttribute = .forceRightToLeft
        $0.isHidden = true
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: 302, height: 60)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(TimeTableCollectionCell.self, forCellWithReuseIdentifier: TimeTableCollectionCell.identifier)
        $0.register(SchoolMealCell.self, forCellWithReuseIdentifier: SchoolMealCell.identifier)
        $0.register(NoticeCell.self, forCellWithReuseIdentifier: NoticeCell.identifier)
    }
    
    public override func attribute() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    public override func layout() {
        [
            titleLabel,
            dateLabel,
            moreButton,
            collectionView
        ].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.left.equalTo(titleLabel.snp.right).offset(8)
        }
        moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(10)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(21)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    public func registerCellIndex(index: Int) {
        mainCellIndex = index
        
        collectionView.reloadData()
    }
    
}

extension MainCell: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mainCellIndex {
            case 0:
                return 10
            case 1:
                return 3
            case 2:
                return 10
            default:
                return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch mainCellIndex {
            case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeTableCollectionCell.identifier, for: indexPath) as? TimeTableCollectionCell
                self.titleLabel.text = "시간표"
                cell?.periodLabel.text = "\(indexPath.row + 1)"
                return cell ?? UICollectionViewCell()
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchoolMealCell.identifier, for: indexPath) as? SchoolMealCell
                self.titleLabel.text = "급식"
                    cell?.schoolMealTimeLabel.text = mealTimeArray[indexPath.row]
                return cell ?? UICollectionViewCell()
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCell.identifier, for: indexPath) as? NoticeCell
                self.titleLabel.text = "공지"
                self.dateLabel.isHidden = true
                self.moreButton.isHidden = false
                return cell ?? UICollectionViewCell()
            default:
                return UICollectionViewCell()
        }
    }
    
    
}

extension MainCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch mainCellIndex {
            case 0:
                return CGSize(width: self.frame.width - 32, height: 40)
            case 1:
                return CGSize(width: self.frame.width - 32, height: 225)
            case 2:
                return CGSize(width: self.frame.width - 32, height: 80)
            default:
                return CGSize()
        }
    }
}
