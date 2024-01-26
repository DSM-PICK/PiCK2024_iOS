import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class LoginViewModel: ViewModelType, Stepper {

    public var steps = PublishRelay<Step>()
    
    public struct Input {
        
    }

    public struct Output {
        
    }
    public func transform(input: Input) -> Output {
        
    }
    

}
