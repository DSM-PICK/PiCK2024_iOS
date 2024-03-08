import Foundation

import RxCocoa
import RxFlow
import RxSwift

import Core

public final class AppStepper: Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    public init() {}
    
    //TODO: 서버통신 시작하면 분기처리하기
    public var initialStep: Step {
        return PiCKStep.testRequired
    }
}
