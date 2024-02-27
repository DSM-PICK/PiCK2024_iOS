import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem

public class SelfStudyTeacherViewController: BaseViewController<SelfStudyTeacherViewModel>, Stepper {
    
    public var steps = PublishRelay<Step>()

    private let navigationTitleLabel = UILabel().then {
        $0.text = "선생님 조회"
        $0.textColor = .neutral50
        $0.font = .subTitle3M
    }
    
    public override func attribute() {
        super.attribute()
        navigationItem.titleView = navigationTitleLabel
    }
    
}
