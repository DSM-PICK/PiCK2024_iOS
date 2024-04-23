import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class SelfStudyTeacherViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    let fetchSelfStudyTeacherUseCase: FetchSelfStudyTeacherUseCase
    
    public init(
        fetchSelfStudyTeacherUseCase: FetchSelfStudyTeacherUseCase
    ) {
        self.fetchSelfStudyTeacherUseCase = fetchSelfStudyTeacherUseCase
    }
    public struct Input {
        let fetchTeacherList: Observable<String>
    }
    public struct Output {
        let teacherList: Driver<SelfStudyTeacherEntity>
    }
    
    private let teacherList = BehaviorRelay<SelfStudyTeacherEntity>(value: [])
    
    public func transform(input: Input) -> Output {
        input.fetchTeacherList.asObservable()
            .flatMap { date in
                self.fetchSelfStudyTeacherUseCase.execute(date: date)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: teacherList)
            .disposed(by: disposeBag)
        
        return Output(
            teacherList: teacherList.asDriver()
        )
    }
    
}
