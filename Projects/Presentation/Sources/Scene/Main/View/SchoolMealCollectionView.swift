import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class SchoolMealCollectionView: BaseView {
    
    private var todaySchoolMeal = BehaviorRelay<[(Int, String, MealEntityElement)]>(value: [])
    
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.frame.width - 32, height: 225)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(
            SchoolMealCell.self,
            forCellWithReuseIdentifier: SchoolMealCell.identifier
        )
    }
    
    public func setup(
        todaySchoolMeal: [(Int, String, MealEntityElement)]
    ) {
        self.todaySchoolMeal.accept(todaySchoolMeal)
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
        todaySchoolMeal.bind(to: collectionView.rx.items(
                cellIdentifier: SchoolMealCell.identifier,
                cellType: SchoolMealCell.self
            )) { row, element, cell in
                cell.setup(
                    mealTime: element.1,
                    todaySchoolMeal: element.2
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
