import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core

public class PiCKSchoolCalendarView: BaseView {
    
    var clickCell: (String, String) -> Void
    
    private var calendar = Calendar.current
    private var dateFormatter = DateFormatter()
    private var date = Date()
    private var days: [String] = []
    private var observeDays = BehaviorRelay<[String]>(value: [])
    private var closureArray = BehaviorRelay<[String]>(value: [])
    
    private let calendarStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
    }
    private let previousButton = UIButton(type: .system).then {
        $0.setImage(.chevronLeftIcon, for: .normal)
        $0.tintColor = .neutral100
    }
    private let dateLabel = UILabel().then {
        $0.textColor = .secondary100
        $0.font = .subTitle3M
    }
    private let nextButton = UIButton(type: .system).then {
        $0.setImage(.chevronRightIcon, for: .normal)
        $0.tintColor = .neutral100
    }
    private lazy var calendarCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = .init(width: 32, height: 32)
        $0.minimumLineSpacing = 4
        $0.minimumInteritemSpacing = 4
    }
    private lazy var calendarCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: calendarCollectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.register(
            SchoolCalendarCell.self,
            forCellWithReuseIdentifier: SchoolCalendarCell.identifier
        )
    }
    
    public init(
        clickCell: @escaping (String, String) -> Void
    ) {
        self.clickCell = clickCell
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func attribute() {
        self.configureCalendar()
    }
    public override func bind() {
        previousButton.rx.tap
            .bind { [weak self] in
                self?.minusMonth()
            }.disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                self?.plusMonth()
            }.disposed(by: disposeBag)
        
        observeDays.bind(to: calendarCollectionView.rx.items(
            cellIdentifier: SchoolCalendarCell.identifier,
            cellType: SchoolCalendarCell.self
        )) { row, element, cell in
            cell.daysLabel.text = element
            
            let todayDate = Date()
            
            if todayDate.toString(type: .fullDateKorForCalendar) == "\(self.dateLabel.text ?? "") \(cell.daysLabel.text ?? "")일" {
                cell.todaySetting()
            }
            
            if cell.daysLabel.text?.isEmpty == true {
                cell.isUserInteractionEnabled = false
            }
            
        }.disposed(by: disposeBag)
        
        calendarCollectionView.rx.itemSelected
            .bind(
                onNext: { value in
                    let clickDate = "\(self.calendar.component(.month, from: self.date))월 \(self.closureArray.value[value.row])일"
                    
                    let loadDate = "\(self.calendar.component(.year, from: self.date))-\(self.calendar.component(.month, from: self.date))-\(self.closureArray.value[value.row])"
                    
                    self.clickCell(clickDate, loadDate.toDate(type: .fullDate).toString(type: .fullDate))
                }
            )
            .disposed(by: disposeBag)
        
    }
    public override func addView() {
        [
            calendarStackView,
            calendarCollectionView
        ].forEach { self.addSubview($0) }
        
        [
            previousButton,
            dateLabel,
            nextButton
        ].forEach { calendarStackView.addArrangedSubview($0) }
    }
    public override func setLayout() {
        calendarStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarStackView.snp.bottom).offset(5)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}

extension PiCKSchoolCalendarView {
    private func configureCalendar() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.date = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.dateFormat = DateFormatIndicated.yearsAndMonthKor.rawValue
        self.updateCalendar()
    }
    
    private func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.date) - 1
    }
    
    private func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.date)?.count ?? Int()
    }
    
    private func updateCalendar() {
        self.updateTitle()
        self.updateDays()
    }
    
    private func updateTitle() {
        let date = self.dateFormatter.string(from: self.date)
        self.dateLabel.text = date
    }
    
    private func updateDays() {
        self.days.removeAll()
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDays = startDayOfTheWeek + self.endDate()
        
        for day in Int()..<totalDays {
            if day < startDayOfTheWeek {
                self.days.append(String())
                continue
            }
            self.days.append("\(day - startDayOfTheWeek + 1)")
        }
        observeDays.accept(days)
        closureArray.accept(days)
        self.calendarCollectionView.reloadData()
    }
    
    private func minusMonth() {
        self.date = self.calendar.date(byAdding: DateComponents(month: -1), to: self.date) ?? Date()
        self.updateCalendar()
    }
    
    private func plusMonth() {
        self.date = self.calendar.date(byAdding: DateComponents(month: 1), to: self.date) ?? Date()
        self.updateCalendar()
    }
    
}
