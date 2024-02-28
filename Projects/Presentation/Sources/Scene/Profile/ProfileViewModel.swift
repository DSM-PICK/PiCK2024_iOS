import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class ProfileViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    private let fetchDetailProfileUseCase: FetchDetailProfileUseCase
    
    public init(fetchDetailProfileUseCase: FetchDetailProfileUseCase) {
        self.fetchDetailProfileUseCase = fetchDetailProfileUseCase
    }
    
    public struct Input {
        let viewWillAppear: Observable<Void>
    }
    public struct Output {
        let userProfileData: Signal<DetailProfileEntity>
    }
    
    let userProfileData = PublishRelay<DetailProfileEntity>()
    
    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.fetchDetailProfileUseCase.excute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: userProfileData)
            .disposed(by: disposeBag)
        
        return Output(userProfileData: userProfileData.asSignal())
    }
    
}
