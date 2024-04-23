import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class ScheduleViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    private let fetchMonthAcademicSchduleUseCase: FetchMonthAcademicScheduleUseCase
    private let fetchWeekTimeTableUseCase: FetchWeekTimeTableUseCase
    
    public init(
        fetchMonthAcademicSchduleUseCase: FetchMonthAcademicScheduleUseCase,
        fetchWeekTimeTableUseCase: FetchWeekTimeTableUseCase
    ) {
        self.fetchMonthAcademicSchduleUseCase = fetchMonthAcademicSchduleUseCase
        self.fetchWeekTimeTableUseCase = fetchWeekTimeTableUseCase
    }
    
    public struct Input {
        let academicScheduleLoad: Observable<String>
        let timeTableLoad: Observable<Void>
    }
    public struct Output {
        //academicSchedule
        let academicScheduleDataLoad: Driver<AcademicScheduleEntity>
        //timeTable
        let timeTableDataLoad: Driver<WeekTimeTableEntity>
    }
    
    //academicSchedule
    let academicScheduleDataLoad = BehaviorRelay<AcademicScheduleEntity>(value: .init())
    //timeTable
    let timeTableDataLoad = BehaviorRelay<WeekTimeTableEntity>(value: .init())
    
    public func transform(input: Input) -> Output {
        let date = Date()
        let thisYear = date.toString(type: .year)
        
        input.academicScheduleLoad.asObservable()
            .flatMap { month in
                self.fetchMonthAcademicSchduleUseCase.execute(
                    year: thisYear,
                    month: month
                )
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: academicScheduleDataLoad)
            .disposed(by: disposeBag)
        
        input.timeTableLoad.asObservable()
            .flatMap {
                self.fetchWeekTimeTableUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: timeTableDataLoad)
            .disposed(by: disposeBag)
        
        return Output(
            academicScheduleDataLoad: academicScheduleDataLoad.asDriver(),
            timeTableDataLoad: timeTableDataLoad.asDriver()
        )
    }
    
}
