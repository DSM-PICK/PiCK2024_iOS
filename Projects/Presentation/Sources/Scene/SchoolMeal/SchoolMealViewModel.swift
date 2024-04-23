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
        let schoolMealDataLoad: Driver<[(Int, String, [String])]>
    }
    
    let schoolMealDataLoad = BehaviorRelay<[(Int, String, [String])]>(value: [])
    
    public func transform(input: Input) -> Output {
        input.schoolMealLoad.asObservable()
            .flatMap { date in
                self.fetchSchoolMealUseCase.execute(date: date)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .map { $0.meals.mealBundle }
            .subscribe(
                onNext: {
                    self.schoolMealDataLoad.accept(
                        $0.sorted(by: {
                            $0.0 < $1.0
                        })
                    )
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            schoolMealDataLoad: schoolMealDataLoad.asDriver()
        )
    }
    
}
