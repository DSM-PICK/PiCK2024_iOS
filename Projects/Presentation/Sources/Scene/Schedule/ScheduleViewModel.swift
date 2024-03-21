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
//        let dateLoad: Driver<String>
        let timeTableDataLoad: Driver<WeekTimeTableEntity>
    }
    
    //academicSchedule
    let academicScheduleDataLoad = PublishRelay<AcademicScheduleEntity>()
    //timeTable
//    let dateDataLoad = PublishRelay<String>()
    let timeTableDataLoad = PublishRelay<WeekTimeTableEntity>()
    
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
            academicScheduleDataLoad: academicScheduleDataLoad.asDriver(onErrorJustReturn: []),
//            dateLoad: dateDataLoad.asDriver(onErrorJustReturn: String()),
            timeTableDataLoad: timeTableDataLoad.asDriver(onErrorJustReturn: [])
        )
    }
    
}
