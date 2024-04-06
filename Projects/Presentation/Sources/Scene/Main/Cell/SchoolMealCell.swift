import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class SchoolMealCell: BaseCollectionViewCell {
    
    private let disposeBag = DisposeBag()
    
    static let identifier = "schoolMealCellID"
    
    private var schoolMealTimeLabel = UILabel().then {
        $0.textColor = .primary200
        $0.font = .subTitle2B
    }
    private var menuLabel = UILabel().then {
        $0.textColor = .neutral50
        $0.font = .body1
        $0.numberOfLines = 0
    }
    
    public func setup(
        mealTime: String,
        todaySchoolMeal: [String]
    ) {
        self.schoolMealTimeLabel.text = mealTime
        if todaySchoolMeal == [""] || todaySchoolMeal == [] {
            self.menuLabel.text = "등록된 급식이 없습니다."
        } else if todaySchoolMeal.first == "" {
            var mealArray = todaySchoolMeal
            mealArray.removeFirst()
            self.menuLabel.text = mealArray.joined(separator: "\n")
        } else {
            self.menuLabel.text = todaySchoolMeal.joined(separator: "\n")
        }
    }
    
    public override func attribute() {
        contentView.backgroundColor = .primary1000
        contentView.layer.cornerRadius = 4
    }
    public override func layout() {
        [
            schoolMealTimeLabel,
            menuLabel
        ].forEach { contentView.addSubview($0) }
        
        schoolMealTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(28)
        }
        menuLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(schoolMealTimeLabel.snp.right).offset(94)
            $0.right.equalToSuperview().inset(15)
        }
    }

}
