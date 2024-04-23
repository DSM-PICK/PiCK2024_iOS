import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class ScrollTimeTableViewCell: BaseCollectionViewCell {
    
    private let timeArray: [String] = [
        "08:40 ~ 09:30",
        "09:40 ~ 10:30",
        "10:40 ~ 11:30",
        "11:40 ~ 12:30",
        "01:30 ~ 02:20",
        "02:30 ~ 03:20",
        "03:30 ~ 04:20"
    ]
    private lazy var timeTableData = PublishRelay<[TimeTableEntityElement]>()
    
    private let disposeBag = DisposeBag()
    
    static let identifier = "scrollTimeTableViewCellID"
    
    private let dateLabel = UILabel().then {
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
        $0.register(
            TimeTableCell.self,
            forCellWithReuseIdentifier: TimeTableCell.identifier
        )
    }
    
    public func setup(
        date: String,
        timeTableData: [TimeTableEntityElement]
    ) {
        self.dateLabel.text = date
        self.timeTableData.accept(timeTableData)
    }
    
    public override func bind() {
        timeTableData.asObservable()
            .bind(to: collectionView.rx.items(
                cellIdentifier: TimeTableCell.identifier,
                cellType: TimeTableCell.self
            )) { row, element, cell in
                cell.setup(
                    period: element.period,
                    subjectImage: SubjectImageType(rawValue: element.subjectName)?.toImage() ?? UIImage(),
                    subject: element.subjectName,
                    time: self.timeArray[row]
                )
            }
            .disposed(by: disposeBag)
    }
    public override func layout() {
        [
            dateLabel,
            collectionView
        ].forEach { self.addSubview($0) }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.left.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(7)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
        }
    }
    
}
