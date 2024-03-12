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
    private let fetchTimeTableUseCase: FetchTimeTableUseCase
    
    public init(
        fetchMonthAcademicSchduleUseCase: FetchMonthAcademicScheduleUseCase,
        fetchTimeTableUseCase: FetchTimeTableUseCase
    ) {
        self.fetchMonthAcademicSchduleUseCase = fetchMonthAcademicSchduleUseCase
        self.fetchTimeTableUseCase = fetchTimeTableUseCase
    }
    
    public struct Input {
        let academicScheduleLoad: Observable<String>
        let timeTableLoad: Observable<String>
    }
    public struct Output {
        //academicSchedule
        let academicScheduleDataLoad: Signal<AcademicScheduleEntity>
        //timeTable
        let dateLoad: Driver<String>
        let timeTableDataLoad: Signal<[TimeTableEntityElement]>
    }
    
    //academicSchedule
    let academicScheduleDataLoad = PublishRelay<AcademicScheduleEntity>()
    //timeTable
    let dateDataLoad = PublishRelay<String>()
    let timeTableDataLoad = PublishRelay<[TimeTableEntityElement]>()
    
    public func transform(input: Input) -> Output {
        let date = Date()
        let thisYear = date.toString(DateFormatIndicated.year.rawValue)
        
        input.academicScheduleLoad.asObservable()
            .flatMap { month in
                self.fetchMonthAcademicSchduleUseCase.excute(
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
            .flatMap { date in
                self.fetchTimeTableUseCase.excute(date: date)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(
                onNext: {
                    self.dateDataLoad.accept($0.date)
                    self.timeTableDataLoad.accept($0.times)
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            academicScheduleDataLoad: academicScheduleDataLoad.asSignal(),
            dateLoad: dateDataLoad.asDriver(onErrorJustReturn: String()),
            timeTableDataLoad: timeTableDataLoad.asSignal()
        )
    }
    
}
