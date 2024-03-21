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
        let classroomMoveApplyButton: Observable<Void>
    }
    public struct Output {
        let isApplyButtonEnable: Signal<Bool>
    }
    
    private var floor = PublishRelay<Int>()
    private var classroomName = PublishRelay<String>()
    
    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.floorText,
            input.classroomNameText
        )
        
        let isApplyButtonEnable = info.map { floor, classroomName -> Bool in !classroomName.isEmpty
        }
        
        input.floorText
            .bind(to: floor)
            .disposed(by: disposeBag)
        
        input.classroomNameText
            .bind(to: classroomName)
            .disposed(by: disposeBag)
        
        input.classroomMoveApplyButton.asObservable()
            .withLatestFrom(info)
            .flatMap { floor, classroomName in
                self.classroomMoveApplyUseCase.execute(
                    floor: floor,
                    classroomName: classroomName
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
