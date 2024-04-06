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
        let startPeriod: Int
        let endPeriod: Int
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
            input.classroomNameText
        )
        
        let isApplyButtonEnable = info.map { floor, classroomName  -> Bool in 
            !classroomName.isEmpty
        }
        
        input.floorText
            .bind(to: floor)
            .disposed(by: disposeBag)
        
        input.classroomNameText
            .bind(to: classroomName)
            .disposed(by: disposeBag)
        
        input.classroomMoveApply.asObservable()
            .withLatestFrom(info)
            .flatMap { floor, classroomName  in
                self.classroomMoveApplyUseCase.execute(
                    floor: floor,
                    classroomName: classroomName,
                    startPeriod: input.startPeriod,
                    endPeriod: input.endPeriod
                )
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
                .andThen(Single.just(PiCKStep.popRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output(
            isApplyButtonEnable: isApplyButtonEnable.asSignal(onErrorJustReturn: false)
        )
    }
    
}
