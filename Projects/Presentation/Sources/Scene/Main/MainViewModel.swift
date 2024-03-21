import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class MainViewModel: BaseViewModel, Stepper {
    
    public var disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    private let fetchSimpleProfileUseCase: FetchSimpleProfileUseCase
    private let fetchClassroomCheckUseCase: FetchClassroomCheckUseCase
    private let classroomReturnUseCase: ClassroomReturnUseCase
    
    //CellData
    private let fetchTodayTimeTableUseCase: FetchTodayTimeTableUseCase
    private let fetchTodaySchoolMealUseCase: FetchSchoolMealUseCase
    private let fetchTodayNoticeListUseCase: FetchTodayNoticeListUseCase
    
    public init(
        fetchSimpleProfileUseCase: FetchSimpleProfileUseCase,
        fetchClassroomCheckUseCase: FetchClassroomCheckUseCase,
        classroomReturnUseCase: ClassroomReturnUseCase,
        fetchTodayTimeTableUseCase: FetchTodayTimeTableUseCase,
        fetchSchoolMealUseCase: FetchSchoolMealUseCase,
        fetchTodayNoticeListUseCase: FetchTodayNoticeListUseCase
    ) {
        self.fetchSimpleProfileUseCase = fetchSimpleProfileUseCase
        self.fetchClassroomCheckUseCase = fetchClassroomCheckUseCase
        self.classroomReturnUseCase = classroomReturnUseCase
        self.fetchTodayTimeTableUseCase = fetchTodayTimeTableUseCase
        self.fetchTodaySchoolMealUseCase = fetchSchoolMealUseCase
        self.fetchTodayNoticeListUseCase = fetchTodayNoticeListUseCase
    }
    
    public struct Input {
        //LoadData
        let userInfoLoad: Observable<Void>
        let classroomCheckLoad: Observable<Void>
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
    }
    
    public struct Output {
        let userProfileData: Signal<SimpleProfileEntity>
        let classroomCheckData: Signal<ClassroomCheckEntity>
        let isHiddenPassView: Signal<Bool>
        
        //CellData
        let todayTimeTableData: Driver<[TimeTableEntityElement]>
        let todaySchoolMealData: Driver<SchoolMealEntity>
        let todayNoticeListData: Driver<TodayNoticeListEntity>
    }
    
    let userProfileData = PublishRelay<SimpleProfileEntity>()
    let classroomCheckData = PublishRelay<ClassroomCheckEntity>()
    let isHiddenPassView = PublishRelay<Bool>()
    
    //CellData
    let todayTimeTableData = PublishRelay<[TimeTableEntityElement]>()
    let todaySchoolMealData = PublishRelay<SchoolMealEntity>()
    let todayNoticeListData = PublishRelay<TodayNoticeListEntity>()
    
    public func transform(input: Input) -> Output {
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
        
        input.classroomCheckLoad.asObservable()
            .flatMap {
                self.fetchClassroomCheckUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: classroomCheckData)
            .disposed(by: disposeBag)
        
        //                input.classroomReturn.asObservable()
        //                    .flatMap {
        //                        self.classroomReturnUseCase.execute()
        //                            .catch {
        //                                print($0.localizedDescription)
        //                                return .never()
        //                            }
        //                    }
        
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
            .bind(to: todaySchoolMealData)
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
        
        return Output(
            userProfileData: userProfileData.asSignal(),
            classroomCheckData: classroomCheckData.asSignal(),
            isHiddenPassView: isHiddenPassView.asSignal(),
            todayTimeTableData: todayTimeTableData.asDriver(onErrorJustReturn: []),
            todaySchoolMealData: todaySchoolMealData.asDriver(
                onErrorJustReturn: .init(
                    meals: [String() : [String()]]
                )
            ),
            todayNoticeListData: todayNoticeListData.asDriver(onErrorJustReturn: [])
        )
    }
    
}
