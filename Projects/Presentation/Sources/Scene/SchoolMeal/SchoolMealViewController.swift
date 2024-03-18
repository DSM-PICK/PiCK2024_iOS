import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import DesignSystem

public class SchoolMealViewController: BaseViewController<SchoolMealViewModel> {
    
    private let schoolMealLoadRelay = PublishRelay<String>()
    
    private let date = Date()
    private lazy var todayDate = date.toString(type: .monthAndDay)
    private lazy var schoolMealDate = date.toString(type: .fullDate)
    
    private let mealTimeArray: [String] = ["조식", "중식", "석식"]
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "급식"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var calendarView = PiCKSchoolMealCalendarView(
        clickCell: { [weak self] date, loadDate in
            if date == self?.todayDate {
                self?.todaysSchoolMealLabel.text = "\(date) 오늘의 급식"
            } else {
                self?.todaysSchoolMealLabel.text = "\(date) 급식"
            }
            self?.schoolMealLoadRelay.accept(loadDate.toString(type: .fullDate))
        })
    private lazy var todaysSchoolMealLabel = UILabel().then {
        $0.text = "\(todayDate) 오늘의 급식"
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private lazy var schoolMealCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.view.frame.width - 48, height: 225)
        $0.minimumLineSpacing = 20
    }
    private lazy var schoolMealCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: schoolMealCollectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(
            SchoolMealCell.self,
            forCellWithReuseIdentifier: SchoolMealCell.identifier
        )
    }
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func bindAction() {
//        schoolMealLoadRelay.accept(schoolMealDate)
        schoolMealLoadRelay.accept("2024-03-18")
    }
//    public override func attribute() {
//        super.attribute()
//        schoolMealCollectionView.delegate = self
//        schoolMealCollectionView.dataSource = self
//    }
    public override func bind() {
        let input = SchoolMealViewModel.Input(
            schoolMealLoad: schoolMealLoadRelay.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.schoolMealDataLoad.asObservable()
            .map { $0.meals }
            .bind(to: schoolMealCollectionView.rx.items(
                cellIdentifier: SchoolMealCell.identifier,
                cellType: SchoolMealCell.self
            )) { [self] row, element, cell in
                cell.setup(
                    mealTime: mealTimeArray[row],
                    todaySchoolMeal: element.value
                )
            }
            .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            calendarView,
            todaysSchoolMealLabel,
            schoolMealCollectionView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(102)
            $0.left.right.equalToSuperview().inset(70)
            $0.height.equalTo(250)
        }
        todaysSchoolMealLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(24)
        }
        schoolMealCollectionView.snp.makeConstraints {
            $0.top.equalTo(todaysSchoolMealLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
    
}
//
//extension SchoolMealViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchoolMealCell.identifier, for: indexPath) as? SchoolMealCell
//        else {
//            return UICollectionViewCell()
//        }
//        switch indexPath.row {
//            case 0:
//                cell.schoolMealTimeLabel.text = "조식"
//                return cell
//            case 1:
//                cell.schoolMealTimeLabel.text = "중식"
//                return cell
//            case 2:
//                cell.schoolMealTimeLabel.text = "석식"
//                return cell
//            default:
//                return cell
//        }
//    }
//    
//    
//}
