import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class OutingPassViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    private let fetchOutingPassUseCase: FetchOutingPassUseCase
    
    public init(
        fetchOutingPassUseCase: FetchOutingPassUseCase
    ) {
        self.fetchOutingPassUseCase = fetchOutingPassUseCase
    }
    
    public struct Input {
        let outingPassLoad: Observable<Void>
    }
    
    public struct Output {
        let outingPassData: Signal<OutingPassEntity>
    }
    
    let outingPassData = PublishRelay<OutingPassEntity>()
    
    public func transform(input: Input) -> Output {
        input.outingPassLoad.asObservable()
            .flatMap {
                self.fetchOutingPassUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: outingPassData)
            .disposed(by: disposeBag)
        
        return Output(
            outingPassData: outingPassData.asSignal()
        )
    }
    
}
