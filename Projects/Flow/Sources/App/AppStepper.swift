import Foundation

import RxCocoa
import RxFlow
import RxSwift

import Core
import Domain
import Data

public final class AppStepper: Stepper {
    public let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    
    private let container = ServiceDI.shared
    private let keychainStorage = KeychainStorage.shared
    
    public init() {}
    
    public var initialStep: Step {
        return PiCKStep.onBoardingRequired
    }
    
    public func readyToEmitSteps() {
        container.loginUseCase.execute(
            accountID: keychainStorage.id ?? "",
            password: keychainStorage.password ?? ""
        )
        .delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
        .subscribe(
            with: self,
            onCompleted: {
                $0.steps.accept(PiCKStep.mainRequired)
            },
            onError: { owner, _ in
                owner.steps.accept(PiCKStep.onBoardingRequired)
            }
        ).disposed(by: disposeBag)
    }
    
}
