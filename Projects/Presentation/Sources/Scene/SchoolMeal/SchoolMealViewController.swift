import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class SchoolMealViewController: BaseViewController<SchoolMealViewModel>, Stepper {
    
    public let steps = PublishRelay<Step>()
    
    private let date = Date()
    private lazy var todayDate = date.toString(DateFormatIndicated.monthAndDay.rawValue)
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "급식"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var calendarView = PiCKSchoolMealCalendarView(
        clickCell: { [weak self] date in
            if date == self?.todayDate {
                self?.todaysSchoolMealLabel.text = "\(date) 오늘의 급식"
            } else {
                self?.todaysSchoolMealLabel.text = "\(date) 급식"
            }
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
        $0.register(SchoolMealCell.self, forCellWithReuseIdentifier: SchoolMealCell.identifier)
    }
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func attribute() {
        schoolMealCollectionView.delegate = self
        schoolMealCollectionView.dataSource = self
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

extension SchoolMealViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SchoolMealCell.identifier, for: indexPath) as? SchoolMealCell
        else {
            return UICollectionViewCell()
        }
        switch indexPath.row {
            case 0:
                cell.schoolMealTimeLabel.text = "조식"
                return cell
            case 1:
                cell.schoolMealTimeLabel.text = "중식"
                return cell
            case 2:
                cell.schoolMealTimeLabel.text = "석식"
                return cell
            default:
                return cell
        }
    }
    
    
}
