import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class ClassroomMoveApplyViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    let classroomMoveApplyUseCase: ClassroomMoveApplyUseCase
    
    public init(classroomMoveApplyUseCase: ClassroomMoveApplyUseCase) {
        self.classroomMoveApplyUseCase = classroomMoveApplyUseCase
    }
    
    public struct Input {
        let floorText: Observable<Int>
        let classroomNameText: Observable<String>
        let classroomMoveApply: Observable<Void>
        let startPeriod: BehaviorRelay<Int>
        let endPeriod: BehaviorRelay<Int>
    }
    public struct Output {
        let isApplyButtonEnable: Signal<Bool>
    }
    
    private var floor = PublishRelay<Int>()
    private var classroomName = PublishRelay<String>()
    private var startPeriod = PublishRelay<Int>()
    private var endPeriod = PublishRelay<Int>()
    
    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.floorText,
            input.classroomNameText,
            input.startPeriod,
            input.endPeriod
        )
        
        let isApplyButtonEnable = info.map { floor, classroomName, startPeriod, endPeriod  -> Bool in
            !classroomName.isEmpty
        }
        
        input.classroomMoveApply.asObservable()
            .withLatestFrom(info)
            .flatMap { floor, classroomName, startPeriod, endPeriod in
                self.classroomMoveApplyUseCase.execute(
                    floor: floor,
                    classroomName: classroomName,
                    startPeriod: startPeriod,
                    endPeriod: endPeriod
                )
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
                .andThen(Single.just(PiCKStep.successAlertRequired(message: "교실이동 신청이 완료 되었습니다.")))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output(
            isApplyButtonEnable: isApplyButtonEnable.asSignal(onErrorJustReturn: false)
        )
    }
    
}
