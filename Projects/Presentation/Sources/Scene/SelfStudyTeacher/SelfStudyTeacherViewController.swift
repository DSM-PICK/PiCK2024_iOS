import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class SelfStudyTeacherViewController: BaseViewController<SelfStudyTeacherViewModel>, Stepper {
    
    public let steps = PublishRelay<Step>()
    
    private let date = Date()
    private lazy var todayDate = date.toString(DateFormatIndicated.monthAndDay.rawValue)
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "선생님 조회"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var calendarView = PiCKSchoolMealCalendarView(
        clickCell: { [weak self] date in
            if date == self?.todayDate {
                self?.todaySelfStudyTeacherLabel.text = "\(date) 오늘의 자습감독 선생님"
            } else {
                self?.todaySelfStudyTeacherLabel.text = "\(date) 자습감독 선생님"
            }
        })
    private lazy var todaySelfStudyTeacherLabel = UILabel().then {
        $0.text = "\(todayDate) 오늘의 자습감독 선생님"
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.view.frame.width - 48, height: 160)
    }
    private lazy var selfStudyTeacherCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(SelfStudyTeacherCell.self, forCellWithReuseIdentifier: SelfStudyTeacherCell.identifier)
    }
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func attribute() {
        super.attribute()
        selfStudyTeacherCollectionView.delegate = self
        selfStudyTeacherCollectionView.dataSource = self
    }
    public override func addView() {
        [
            calendarView,
            todaySelfStudyTeacherLabel,
            selfStudyTeacherCollectionView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(102)
            $0.left.right.equalToSuperview().inset(70)
            $0.height.equalTo(250)
        }
        todaySelfStudyTeacherLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(24)
        }
        selfStudyTeacherCollectionView.snp.makeConstraints {
            $0.top.equalTo(todaySelfStudyTeacherLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
    
}

extension SelfStudyTeacherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelfStudyTeacherCell.identifier, for: indexPath) as? SelfStudyTeacherCell
        else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
}

