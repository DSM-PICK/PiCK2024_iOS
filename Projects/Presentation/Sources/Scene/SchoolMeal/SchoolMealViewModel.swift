import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class SchoolMealViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    private let fetchSchoolMealUseCase: FetchSchoolMealUseCase
    
    public init(
        fetchSchoolMealUseCase: FetchSchoolMealUseCase
    ) {
        self.fetchSchoolMealUseCase = fetchSchoolMealUseCase
    }
    
    public struct Input {
        let schoolMealLoad: Observable<String>
    }
    
    public struct Output {
        //        let date: Signal<String>
        let schoolMealDataLoad: Driver<SchoolMealEntity>
    }
    
//        let date = PublishRelay<String>()
    let schoolMealDataLoad = PublishRelay<SchoolMealEntity>()
    
    public func transform(input: Input) -> Output {
        input.schoolMealLoad.asObservable()
            .flatMap { date in
                self.fetchSchoolMealUseCase.excute(date: date)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(
                onNext: {
                    self.schoolMealDataLoad.accept(.init(meals: $0.meals))
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            //            date: date.asSignal(),
            schoolMealDataLoad: schoolMealDataLoad.asDriver(onErrorJustReturn: .init(
                meals: [String() : [String()]]
                    )
            )
        )
    }
    
}
