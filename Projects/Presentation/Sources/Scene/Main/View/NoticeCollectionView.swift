import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class NoticeCollectionView: BaseView {
    
    public var clickNoticeCell: ((UUID) -> Void)?
    
    private var noticeList = BehaviorRelay<NoticeListEntity>(value: [])
    
    private let todayDate = Date()
    
    private let emptyNoticeLabel = UILabel().then {
        $0.text = "등록된 공지가 없습니다."
        $0.textColor = .neutral50
        $0.font = .caption1
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(
            width: self.frame.width - 32,
            height: 80
        )
    }
    public lazy var collectionView = UICollectionView(
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
        noticeList: NoticeListEntity
    ) {
        let limitList = Array(noticeList.prefix(5))
        self.noticeList.accept(limitList)
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
        noticeList.subscribe(
            onNext: {
                if $0.isEmpty {
                    self.collectionView.isHidden = true
                    self.emptyNoticeLabel.isHidden = false
                } else {
                    self.collectionView.isHidden = false
                    self.emptyNoticeLabel.isHidden = true
                }
            }
        )
        .disposed(by: disposeBag)
        
        noticeList.bind(to: collectionView.rx.items(
            cellIdentifier: NoticeCell.identifier,
            cellType: NoticeCell.self
        )) { row, element, cell in
            cell.setup(
                id: element.id,
                title: element.title,
                date: element.createAt
            )
            if element.createAt == self.todayDate.toString(type: .fullDate) {
                cell.newNoticeIconImageView.isHidden = false
            }
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                self?.clickNoticeCell?(self?.noticeList.value[indexPath.row].id ?? UUID())
            }
        )
        .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            emptyNoticeLabel,
            collectionView
        ].forEach { self.addSubview($0) }
    }
    public override func setLayout() {
        emptyNoticeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
    }
    
}
