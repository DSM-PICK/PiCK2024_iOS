import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class MainCell: BaseCollectionViewCell {
    
    public let disposeBag = DisposeBag()
    
    var mainCellIndex: Int = 0
    
    private let date = Date()
    private lazy var todayDate = date.toString(type: .dateAndDays)
    private let mealTimeArray: [String] = ["조식", "중식", "석식"]
    
    static let identifier = "mainCellID"
    
    private let titleLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    private lazy var dateLabel = UILabel().then {
        $0.text = todayDate
        $0.textColor = .neutral300
        $0.font = .body3
    }
    public let moreButton = UIButton(type: .system).then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.neutral200, for: .normal)
        $0.titleLabel?.font = .body3
        $0.semanticContentAttribute = .forceRightToLeft
        $0.isHidden = true
    }
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        //콜렉션뷰 itemsize를 따로 변수로 빼서 case별로 해보기
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.register(
            TimeTableCollectionCell.self,
            forCellWithReuseIdentifier: TimeTableCollectionCell.identifier
        )
        $0.register(
            SchoolMealCell.self,
            forCellWithReuseIdentifier: SchoolMealCell.identifier
        )
        $0.register(
            NoticeCell.self,
            forCellWithReuseIdentifier: NoticeCell.identifier
        )
    }
    var todayTimeTable = BehaviorRelay<[TimeTableEntityElement]>(value: [])
    var todaySchoolMeal = BehaviorRelay<[String: [String]]>(value: .init())
    var todayNoticeList = BehaviorRelay<TodayNoticeListEntity>(value: [])
    
    private func configureUI(
        title: String,
        buttonVisiable: Bool,
        dateVisiable: Bool
    ) {
        self.titleLabel.text = title
        self.moreButton.isHidden = buttonVisiable
        self.dateLabel.isHidden = dateVisiable
    }
    
    public func setup(
        todayTimeTable: [TimeTableEntityElement],
        todaySchoolMeal: [String: [String]],
        todayNoticeList: TodayNoticeListEntity
    ) {
        self.todayTimeTable.accept(todayTimeTable)
        self.todaySchoolMeal.accept(todaySchoolMeal)
        self.todayNoticeList.accept(todayNoticeList)
    }
    
    public override func attribute() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
//    public override func bind() {
//                    todayTimeTable.bind(to: collectionView.rx.items(
//                        cellIdentifier: TimeTableCollectionCell.identifier,
//                        cellType: TimeTableCollectionCell.self
//                    )) { row, element, cell in
//                        cell.setup(
//                            period: element.period,
//                            subject: element.subjectName
//                        )
//                    }
//                    .disposed(by: disposeBag)
//        
//        switch mainCellIndex {
//            case 0:
//                todayTimeTable.bind(to: collectionView.rx.items(
//                    cellIdentifier: TimeTableCollectionCell.identifier,
//                    cellType: TimeTableCollectionCell.self
//                )) { row, element, cell in
//                    cell.setup(
//                        period: element.period,
//                        subject: element.subjectName
//                    )
//                }
//                .disposed(by: disposeBag)
//                //            case 1:
//                //                todaySchoolMeal.value.meals
//                //                bind(to: collectionView.rx.items(
//                //                    cellIdentifier: SchoolMealCell.identifier,
//                //                    cellType: SchoolMealCell.self
//                //                )) { row, element, cell in
//                //                    cell.setup(
//                //                        todaySchoolMeal: element.breakfast
//                //                    )
//                //                }
//            case 2:
//                todayNoticeList.bind(to: collectionView.rx.items(
//                    cellIdentifier: NoticeCell.identifier,
//                    cellType: NoticeCell.self
//                )) { row, element, cell in
//                    cell.setup(
//                        id: element.id,
//                        title: element.title,
//                        date: element.createAt
//                    )
//                }
//                .disposed(by: disposeBag)
//            default:
//                return
//        }
//    }
    public override func configureUI() {
        switch mainCellIndex {
            case 0:
                configureUI(
                    title: "시간표",
                    buttonVisiable: true,
                    dateVisiable: false
                )
            case 1:
                configureUI(
                    title: "급식",
                    buttonVisiable: true,
                    dateVisiable: false
                )
            case 2:
                configureUI(
                    title: "공지",
                    buttonVisiable: false,
                    dateVisiable: true
                )
            default:
                return
        }
    }
    public override func layout() {
        [
            titleLabel,
            dateLabel,
            moreButton,
            collectionView
        ].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.left.equalTo(titleLabel.snp.right).offset(8)
        }
        moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(10)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(21)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    public func registerCellIndex(index: Int) {
        mainCellIndex = index
        
        collectionView.reloadData()
    }
    
}

extension MainCell: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch mainCellIndex {
            case 0:
                return todayTimeTable.value.count
            case 1:
                return todaySchoolMeal.value.count
            case 2:
                return todayNoticeList.value.count
            default:
                return 0
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch mainCellIndex {
            case 0:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TimeTableCollectionCell.identifier,
                    for: indexPath
                ) as? TimeTableCollectionCell
                cell?.setup(
                    period: todayTimeTable.value[indexPath.row].period,
                    subject: todayTimeTable.value[indexPath.row].subjectName
                )
                return cell ?? UICollectionViewCell()
            case 1:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SchoolMealCell.identifier,
                    for: indexPath
                ) as? SchoolMealCell
                cell?.schoolMealTimeLabel.text = mealTimeArray[indexPath.row]
                cell?.setup(
                    mealTime: mealTimeArray[indexPath.row],
                    todaySchoolMeal: todaySchoolMeal.value.map { $0.value[indexPath.row] }
                )
                print("---------------여기ㅣㅣㅣ")
                print(todaySchoolMeal.value.map { $0.value[indexPath.row] })
                print("---------------까지ㅣㅣㅣㅣㅣ")
                return cell ?? UICollectionViewCell()
            case 2:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NoticeCell.identifier,
                    for: indexPath
                ) as? NoticeCell
                cell?.setup(
                    id: todayNoticeList.value[indexPath.row].id,
                    title: todayNoticeList.value[indexPath.row].title,
                    date: todayNoticeList.value[indexPath.row].createAt
                )
                return cell ?? UICollectionViewCell()
            default:
                return UICollectionViewCell()
        }
    }

}

extension MainCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch mainCellIndex {
            case 0:
                return CGSize(width: self.frame.width - 32, height: 60)
            case 1:
                return CGSize(width: self.frame.width - 32, height: 225)
            case 2:
                return CGSize(width: self.frame.width - 32, height: 80)
            default:
                return CGSize()
        }
    }

}
