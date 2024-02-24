import UIKit

import SnapKit
import Then

import Core
import DesignSystem

public class AcademicScheduleView: BaseView {
    
    private let calendarView = PiCKAcademicScheduleCalendarView()
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
        $0.bounces = false
        $0.showsVerticalScrollIndicator = false
        $0.register(AcademicScheduleCell.self, forCellWithReuseIdentifier: AcademicScheduleCell.identifier)
    }
    
    public override func attribute() {
        self.backgroundColor = .white
        scheduleCollectionView.delegate = self
        scheduleCollectionView.dataSource = self
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
            $0.height.equalTo(300)
        }
        scheduleCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(16)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}

extension AcademicScheduleView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AcademicScheduleCell.identifier, for: indexPath) as? AcademicScheduleCell
        else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
}
