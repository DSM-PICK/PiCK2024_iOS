import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class NoticeCollectionView: BaseView {
    
    private var todayNoticeList = BehaviorRelay<TodayNoticeListEntity>(value: [])
    
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.frame.width - 32, height: 80)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.register(
            NoticeCell.self,
            forCellWithReuseIdentifier: NoticeCell.identifier
        )
    }
    
    public func setup(
        todayNoticeList: TodayNoticeListEntity
    ) {
        self.todayNoticeList.accept(todayNoticeList)
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
        todayNoticeList.bind(to: collectionView.rx.items(
            cellIdentifier: NoticeCell.identifier,
            cellType: NoticeCell.self
        )) { row, element, cell in
            cell.setup(
                id: element.id,
                title: element.title,
                date: element.createAt
            )
        }
        .disposed(by: disposeBag)
    }
    public override func setLayout() {
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
    }
    
}
    
