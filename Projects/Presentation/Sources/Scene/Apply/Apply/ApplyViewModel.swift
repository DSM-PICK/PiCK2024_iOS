import Foundation
import UIKit

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class ApplyViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    let weekendMealCheckUseCase: WeekendMealCheckUseCase
    let weekendMealApplyUseCase: WeekendMealApplyUseCase
    
    public init(
        weekendMealCheckUseCase: WeekendMealCheckUseCase,
        weekendMealApplyUseCase: WeekendMealApplyUseCase
    ) {
        self.weekendMealCheckUseCase = weekendMealCheckUseCase
        self.weekendMealApplyUseCase = weekendMealApplyUseCase
    }
    
    public struct Input {
        let viewWillAppear: Observable<Void>
        let weekendMealApply: Observable<WeekendMealTypeEnum>
        let classroomMoveApplyViewDidClick: Observable<UITapGestureRecognizer>
        let outingApplyViewDidClick: Observable<UITapGestureRecognizer>
        let earlyLeaveApplyViewDidClick: Observable<UITapGestureRecognizer>
    }
    
    public struct Output {
        let weekendMealCheck: Signal<WeekendMealCheckEntity>
    }
    
    let weekendMealCheck = PublishRelay<WeekendMealCheckEntity>()
    
    public func transform(input: Input) -> Output {
        input.viewWillAppear.asObservable()
            .flatMap {
                self.weekendMealCheckUseCase.excute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: weekendMealCheck)
            .disposed(by: disposeBag)
        
        input.weekendMealApply.asObservable()
            .flatMap { status in
                self.weekendMealApplyUseCase.excute(status: status.rawValue)
            }.subscribe(
                onCompleted: {
                    print("Completed")
                }
            )
            .disposed(by: disposeBag)
        
        input.classroomMoveApplyViewDidClick
            .map { _ in PiCKStep.classroomMoveApplyRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.outingApplyViewDidClick
            .map { _ in PiCKStep.outingApplyRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.earlyLeaveApplyViewDidClick
            .map { _ in PiCKStep.earlyLeaveApplyRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output(
            weekendMealCheck: weekendMealCheck.asSignal()
        )
    }
    
}
