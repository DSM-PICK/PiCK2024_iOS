import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class NoticeListViewController: BaseViewController<NoticeListViewModel>, Stepper {
    
    public let steps = PublishRelay<Step>()
    
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
        $0.register(NoticeCell.self, forCellWithReuseIdentifier: NoticeCell.identifier)
    }
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func attribute() {
        super.attribute()
        noticeCollectionView.delegate = self
        noticeCollectionView.dataSource = self
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

extension NoticeListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCell.identifier, for: indexPath) as? NoticeCell
        else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? NoticeCell
        self.steps.accept(PiCKStep.detailNoticeRequired)
    }
    
}
