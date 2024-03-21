import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class SelfStudyTeacherViewController: BaseViewController<SelfStudyTeacherViewModel> {
    
    private let fetchTeacherListRelay = PublishRelay<String>()
    
    private let date = Date()
    private lazy var calendarTodayDate = date.toString(type: .monthAndDay)
    private lazy var todayDate = date.toString(type: .fullDate)
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "선생님 조회"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var calendarView = PiCKSchoolMealCalendarView(
        clickCell: { [weak self] date, loadDate in
            if date == self?.calendarTodayDate {
                self?.todaySelfStudyTeacherLabel.text = "\(date) 오늘의 자습감독 선생님"
            } else {
                self?.todaySelfStudyTeacherLabel.text = "\(date) 자습감독 선생님"
            }
            self?.fetchTeacherListRelay.accept(loadDate)
        }
    )
    private lazy var todaySelfStudyTeacherLabel = UILabel().then {
        $0.text = "\(calendarTodayDate) 오늘의 자습감독 선생님"
        $0.textColor = .black
        $0.font = .subTitle3M
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = -5
        $0.itemSize = .init(width: self.view.frame.width - 48, height: 60)
    }
    private lazy var selfStudyTeacherCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(
            SelfStudyTeacherCell.self,
            forCellWithReuseIdentifier: SelfStudyTeacherCell.identifier
        )
    }
    
    public override func configureNavigationBar() {
        navigationItem.titleView = navigationTitleLabel
    }
    public override func bindAction() {
        fetchTeacherListRelay.accept(todayDate)
    }
    public override func bind() {
        let input = SelfStudyTeacherViewModel.Input(
            fetchTeacherList: fetchTeacherListRelay.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.teacherList.asObservable()
            .bind(to: selfStudyTeacherCollectionView.rx.items(
                cellIdentifier: SelfStudyTeacherCell.identifier,
                cellType: SelfStudyTeacherCell.self
            )) { row, element, cell in
                cell.setup(
                    flooor: element.floor,
                    teacher: element.teacherName
                )
            }
            .disposed(by: disposeBag)
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
