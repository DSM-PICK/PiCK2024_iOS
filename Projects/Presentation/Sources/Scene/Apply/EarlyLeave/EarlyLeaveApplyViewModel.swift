import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class EarlyLeaveApplyViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    let earlyLeaveApplyUseCase: EarlyLeaveApplyUseCase
    
    public init(earlyLeaveApplyUseCase: EarlyLeaveApplyUseCase) {
        self.earlyLeaveApplyUseCase = earlyLeaveApplyUseCase
    }
    
    public struct Input {
        let reasonText: Observable<String>
        let startTimeText: Observable<String>
        let earlyLeaveApplyButton: Observable<Void>
    }
    public struct Output {
        let isApplyButtonEnable: Signal<Bool>
    }
    
    private var reason = PublishRelay<String>()
    private var startTime = PublishRelay<String>()
    
    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.reasonText,
            input.startTimeText
        )
        
        let isApplyButtonEnable = info.map { reason, startTime -> Bool in !reason.isEmpty && !startTime.isEmpty
        }
        
        input.reasonText
            .bind(to: reason)
            .disposed(by: disposeBag)
        
        input.startTimeText
            .bind(to: startTime)
            .disposed(by: disposeBag)
        
        input.earlyLeaveApplyButton.asObservable()
            .withLatestFrom(info)
            .flatMap { reason, startTime in
                self.earlyLeaveApplyUseCase.execute(
                    reason: reason,
                    startTime: startTime
                )
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
                    .andThen(Single.just(PiCKStep.popRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output(isApplyButtonEnable: isApplyButtonEnable.asSignal(onErrorJustReturn: false)
        )
    }
    
}
