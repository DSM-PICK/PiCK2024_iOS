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
    private let fetchEarlyLeavePassUseCase: FetchEarlyLeavePassUseCase
    
    public init(
        fetchOutingPassUseCase: FetchOutingPassUseCase,
        fetchEarlyLeavePassUseCase: FetchEarlyLeavePassUseCase) {
        self.fetchOutingPassUseCase = fetchOutingPassUseCase
        self.fetchEarlyLeavePassUseCase = fetchEarlyLeavePassUseCase
    }
    
    public struct Input {
        let outingPassLoad: Observable<Void>
    }
    
    public struct Output {
        let outingPassData: Signal<OutingPassEntity>
//        let earlyLeavePassData: Signal<EarlyLeavePassEntity>
    }
    
    let outingPassData = PublishRelay<OutingPassEntity>()
//    let earlyLeavePassData = PublishRelay<EarlyLeavePassEntity>()
    
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
        
        input.outingPassLoad.asObservable()
            .flatMap {
                self.fetchEarlyLeavePassUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: outingPassData)
            .disposed(by: disposeBag)
        
        return Output(
            outingPassData: outingPassData.asSignal()
//            earlyLeavePassData: earlyLeavePassData.asSignal()
        )
    }
    
}
