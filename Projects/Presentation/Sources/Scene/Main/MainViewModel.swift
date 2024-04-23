import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class MainViewModel: BaseViewModel, Stepper {
    
    public var disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    private let fetchMainUseCase: FetchMainUseCase
    
    private let fetchSimpleProfileUseCase: FetchSimpleProfileUseCase
    private let classroomReturnUseCase: ClassroomReturnUseCase
    
    //CellData
    private let fetchTodayTimeTableUseCase: FetchTodayTimeTableUseCase
    private let fetchTodaySchoolMealUseCase: FetchSchoolMealUseCase
    private let fetchTodayNoticeListUseCase: FetchTodayNoticeListUseCase
    
    public init(
        fetchMainUseCase: FetchMainUseCase,
        fetchSimpleProfileUseCase: FetchSimpleProfileUseCase,
        classroomReturnUseCase: ClassroomReturnUseCase,
        fetchTodayTimeTableUseCase: FetchTodayTimeTableUseCase,
        fetchSchoolMealUseCase: FetchSchoolMealUseCase,
        fetchTodayNoticeListUseCase: FetchTodayNoticeListUseCase
    ) {
        self.fetchMainUseCase = fetchMainUseCase
        self.fetchSimpleProfileUseCase = fetchSimpleProfileUseCase
        self.classroomReturnUseCase = classroomReturnUseCase
        self.fetchTodayTimeTableUseCase = fetchTodayTimeTableUseCase
        self.fetchTodaySchoolMealUseCase = fetchSchoolMealUseCase
        self.fetchTodayNoticeListUseCase = fetchTodayNoticeListUseCase
    }
    
    public struct Input {
        //LoadData
        let mainDataLoad: Observable<Void>
        let userInfoLoad: Observable<Void>
        let classroomReturn: Observable<Void>
        
        //LoadCellData
        let todayTimeTableLoad: Observable<Void>
        let todaySchoolMealLoad: Observable<String>
        let todayNoticeListLoad: Observable<Void>
        
        //ButtonClick
        let profileButtonDidClick: Observable<Void>
        let scheduleButtonDidClick: Observable<Void>
        let applyButtonDidClick: Observable<Void>
        let schoolMealButtonDidClick: Observable<Void>
        let selfStudyTeacherButtonDidClick: Observable<Void>
        let outingPassButtonDidClick: Observable<Void>
        let noticeButtonDidClick: Observable<Void>
        let noticeCellDidClick: Observable<UUID>
    }
    
    public struct Output {
        let mainData: Signal<MainEntity?>
        let userProfileData: Signal<SimpleProfileEntity>
        
        //CellData
        let todayTimeTableData: Driver<[TimeTableEntityElement]>
        let todaySchoolMealData: Driver<[(Int, String, [String])]>
        let todayNoticeListData: Driver<TodayNoticeListEntity>
    }
    
    let mainData = PublishRelay<MainEntity?>()
    let userProfileData = PublishRelay<SimpleProfileEntity>()
    
    //CellData
    let todayTimeTableData = BehaviorRelay<[TimeTableEntityElement]>(value: [])
    let todaySchoolMealData = BehaviorRelay<[(Int, String, [String])]>(value: [])
    let todayNoticeListData = BehaviorRelay<TodayNoticeListEntity>(value: [])
    
    public func transform(input: Input) -> Output {
        input.mainDataLoad
            .flatMap {
                self.fetchMainUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .just(nil)
                    }
            }
            .bind(to: mainData)
            .disposed(by: disposeBag)
        
        input.userInfoLoad
            .flatMap {
                self.fetchSimpleProfileUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: userProfileData)
            .disposed(by: disposeBag)
        
        input.classroomReturn.asObservable()
            .flatMap {
                self.classroomReturnUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(
                onCompleted: {
                    print("Completed")
                }
            )
            .disposed(by: disposeBag)
        
        
        input.todayTimeTableLoad.asObservable()
            .flatMap {
                self.fetchTodayTimeTableUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(
                onNext: {
                    self.todayTimeTableData.accept($0.timetables)
                }
            )
            .disposed(by: disposeBag)
        
                input.todaySchoolMealLoad.asObservable()
                    .flatMap { date in
                        self.fetchTodaySchoolMealUseCase.execute(date: date)
                            .catch {
                                print($0.localizedDescription)
                                return .never()
                            }
                    }
                    .map { $0.meals.mealBundle }
                    .subscribe(
                        onNext: {
                            self.todaySchoolMealData.accept(
                                $0.sorted(by: {
                                    $0.0 < $1.0
                                })
                            )
                        }
                    )
                    .disposed(by: disposeBag)
        
        input.todayNoticeListLoad.asObservable()
            .flatMap {
                self.fetchTodayNoticeListUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: todayNoticeListData)
            .disposed(by: disposeBag)
        
        input.profileButtonDidClick
            .map { PiCKStep.profileRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.scheduleButtonDidClick
            .map { PiCKStep.scheduleRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.applyButtonDidClick
            .map { PiCKStep.applyRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.schoolMealButtonDidClick
            .map { PiCKStep.schoolMealRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.selfStudyTeacherButtonDidClick
            .map { PiCKStep.selfStudyTeacherRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.outingPassButtonDidClick
            .map { PiCKStep.outingPassRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.noticeButtonDidClick
            .throttle(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .map { PiCKStep.noticeRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.noticeCellDidClick
            .map { id in
                PiCKStep.detailNoticeRequired(id: id)
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output(
            mainData: mainData.asSignal(),
            userProfileData: userProfileData.asSignal(),
            todayTimeTableData: todayTimeTableData.asDriver(),
            todaySchoolMealData: todaySchoolMealData.asDriver(),
            todayNoticeListData: todayNoticeListData.asDriver()
        )
    }
    
}
