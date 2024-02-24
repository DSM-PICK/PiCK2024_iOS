import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class ScrollTimeTableView: BaseView {
    
    private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.itemSize = .init(width: self.frame.width, height: self.frame.height)
    }
    private lazy var colletionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.bounces = false
        $0.register(ScrollTimeTableViewCell.self, forCellWithReuseIdentifier: ScrollTimeTableViewCell.identifier)
    }
    private let pageControl = PiCKPageControl().then {
        $0.numberOfPages = 5
        $0.currentPage = 0
        $0.backgroundColor = .white
        $0.currentPageIndicatorTintColor = .primary300
        $0.pageIndicatorTintColor = .neutral600
        $0.allowsContinuousInteraction = false
        $0.isEnabled = false
        $0.dotRadius = 4
        $0.dotSpacings = 4
    }
    
    public override func attribute() {
        colletionView.delegate = self
        colletionView.dataSource = self
    }
    public override func addView() {
        [
            colletionView,
            pageControl
        ].forEach { self.addSubview($0) }
    }
    public override func setLayout() {
        colletionView.snp.makeConstraints {
//            $0.top.left.right.equalToSuperview()
//            $0.bottom.equalToSuperview().inset(30)
            $0.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(colletionView.snp.bottom).offset(17)
        }
    }
    
}

extension ScrollTimeTableView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrollTimeTableViewCell.identifier, for: indexPath) as? ScrollTimeTableViewCell
        else {
            return UICollectionViewCell()
        }
        return cell
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScroll(scrollView)
    }
    
}
