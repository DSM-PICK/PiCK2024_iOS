import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class EarlyLeaveApplyViewModel: ViewModelType, Stepper {
    
    public var steps = PublishRelay<Step>()
    
    public init(steps: PublishRelay<Step> = PublishRelay<Step>()) {
        self.steps = steps
    }
    
    public struct Input {
        
    }
    public struct Output {
        
    }
    
    public func transform(input: Input) -> Output {
        return Output()
    }
    
}
