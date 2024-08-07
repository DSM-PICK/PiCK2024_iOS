import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class TimeTableCollectionView: BaseView {
    
    private let timeArray: [String] = [
        "08:40 ~ 09:30",
        "09:40 ~ 10:30",
        "10:40 ~ 11:30",
        "11:40 ~ 12:30",
        "01:30 ~ 02:20",
        "02:30 ~ 03:20",
        "03:30 ~ 04:20"
    ]
    
    private var todayTimeTable = BehaviorRelay<[TimeTableEntityElement]>(value: [])
    
    private let emptyTimeTableLabel = UILabel().then {
        $0.text = "오늘은 등록된 시간표가 없습니다."
        $0.textColor = .neutral50
        $0.font = .caption1
        $0.isHidden = true
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.frame.width - 32, height: 60)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(
            TimeTableCollectionCell.self,
            forCellWithReuseIdentifier: TimeTableCollectionCell.identifier
        )
    }
    
    public func setup(
        todayTimeTable: [TimeTableEntityElement]
    ) {
        self.todayTimeTable.accept(todayTimeTable)
        self.collectionView.reloadData()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func bind() {
        todayTimeTable.subscribe(
            onNext: {
                if $0.isEmpty {
                    self.collectionView.isHidden = true
                    self.emptyTimeTableLabel.isHidden = false
                } else {
                    self.collectionView.isHidden = false
                    self.emptyTimeTableLabel.isHidden = true
                }
            }
        )
        .disposed(by: disposeBag)
        
        todayTimeTable.bind(to: collectionView.rx.items(
            cellIdentifier: TimeTableCollectionCell.identifier,
            cellType: TimeTableCollectionCell.self
        )) { row, element, cell in
            cell.setup(
                period: element.period,
                subjectImage: element.subjectImage,
                subject: element.subjectName
            )
        }
        .disposed(by: disposeBag)
    }
    public override func setLayout() {
        [
            emptyTimeTableLabel,
            collectionView
        ].forEach { self.addSubview($0) }
        
        emptyTimeTableLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
    }
    
}
  
