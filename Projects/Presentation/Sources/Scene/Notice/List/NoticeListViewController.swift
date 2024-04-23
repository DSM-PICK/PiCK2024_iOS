import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class NoticeListViewController: BaseViewController<NoticeListViewModel> {
    
    private let viewWillAppearRelay = PublishRelay<Void>()
    private let clickNoticeCell = PublishRelay<UUID>()
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "공지사항"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.view.frame.width, height: 80)
    }
    private lazy var noticeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(
            NoticeCell.self,
            forCellWithReuseIdentifier: NoticeCell.identifier
        )
    }
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func bindAction() {
        viewWillAppearRelay.accept(())
    }
    public override func bind() {
        let input = NoticeListViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            noticeCellDidClick: clickNoticeCell.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.noticeListData.asObservable()
            .bind(to: noticeCollectionView.rx.items(
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
        
        noticeCollectionView.rx.modelSelected(NoticeListEntityElement.self)
            .subscribe(
                onNext: { [weak self] data in
                    self?.clickNoticeCell.accept(data.id)
                }
            )
            .disposed(by: disposeBag)
        
    }
    public override func addView() {
        view.addSubview(noticeCollectionView)
    }
    public override func setLayout() {
        noticeCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(106)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}
