import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class OutingApplyViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    let outingApplyUseCase: OutingApplyUseCase
    
    public init(outingApplyUseCase: OutingApplyUseCase) {
        self.outingApplyUseCase = outingApplyUseCase
    }
    
    public struct Input {
        let reasonText: Observable<String>
        let startTimeText: Observable<String>
        let endTimeText: Observable<String>
        let outingApplyButton: Observable<Void>
    }
    public struct Output {
        let isApplyButtonEnable: Signal<Bool>
    }
    
    private var reason = PublishRelay<String>()
    private var startTime = PublishRelay<String>()
    private var endTime = PublishRelay<String>()
    
    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.reasonText,
            input.startTimeText,
            input.endTimeText
        )
        
        let isApplyButtonEnable = info.map { reason, startTime, endTime -> Bool in !reason.isEmpty && !startTime.isEmpty && !endTime.isEmpty
        }
        
        input.reasonText
            .bind(to: reason)
            .disposed(by: disposeBag)
        
        input.startTimeText
            .bind(to: startTime)
            .disposed(by: disposeBag)
        
        input.endTimeText
            .bind(to: endTime)
            .disposed(by: disposeBag)
        
        input.outingApplyButton.asObservable()
            .withLatestFrom(info)
            .flatMap { reason, startTime, endTime in
                self.outingApplyUseCase.excute(
                    reason: reason,
                    startTime: startTime,
                    endTime: endTime
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
