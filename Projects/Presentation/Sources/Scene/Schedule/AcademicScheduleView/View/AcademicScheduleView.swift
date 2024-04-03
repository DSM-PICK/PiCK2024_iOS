import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class AcademicScheduleView: BaseView {
    
    private var clickToAction: (String) -> Void
    
    private var scheduleArray = BehaviorRelay<AcademicScheduleEntity>(value: [])
    private var month = String()
    
    private lazy var calendarView = PiCKAcademicScheduleCalendarView(click: { date in
        self.month = date.toStringEng(type:.fullMonth)
        self.clickToAction(self.month)
    })
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.frame.width, height: 60)
        $0.minimumLineSpacing = 12
    }
    private lazy var scheduleCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 4
        $0.register(
            AcademicScheduleCell.self,
            forCellWithReuseIdentifier: AcademicScheduleCell.identifier
        )
    }
    
    public func setup(
        academicSchedule: AcademicScheduleEntity
    ) {
        self.scheduleArray.accept(academicSchedule)
        self.calendarView.setup(academicSchedule: academicSchedule)
    }
    
    public init(
        clickToAction: @escaping (String) -> Void,
        frame: CGRect
    ) {
        self.clickToAction = clickToAction
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func bind() {
        scheduleArray.bind(to: scheduleCollectionView.rx.items(
            cellIdentifier: AcademicScheduleCell.identifier,
            cellType: AcademicScheduleCell.self
        )) { row, element, cell in
            cell.setup(
                id: element.id,
                day: element.day,
                dayOfWeek: element.dayName,
                schedule: element.eventName
            )
        }
        .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            calendarView,
            scheduleCollectionView
        ].forEach { self.addSubview($0) }
    }
    public override func setLayout() {
        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(330)
        }
        scheduleCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(16)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}
