import Domain
import Data
import Presentation

public struct StepperDI {
    public static let shared = resolve()
    
    public let onboardingViewModel: OnboardingViewModel
    public let loginViewModel: LoginViewModel
    public let mainViewModel: MainViewModel
    public let applyViewModel: ApplyViewModel
    public let profileViewModel: ProfileViewModel
    public let outingViewModel: OutingApplyViewModel
    public let outingPassViewModel: OutingPassViewModel
    public let earlyLeaveViewModel: EarlyLeaveApplyViewModel
    public let classroomMoveViewModel: ClassroomMoveApplyViewModel
    public let selfStudyTeacherViewModel: SelfStudyTeacherViewModel
    public let noticeListViewModel: NoticeListViewModel
    public let detailNoticeViewModel: DetailNoticeViewModel
    public let scheduleViewModel: ScheduleViewModel
    public let schoolMealViewModel: SchoolMealViewModel
}

extension StepperDI {
    private static func resolve() -> StepperDI {

        let serviceDI = ServiceDI.shared
        
        //MARK: OnboardingViewModel
        let onboardingViewModel = OnboardingViewModel()
        
        //MARK: LoginViewModel
        let loginViewModel = LoginViewModel(
            loginUseCase: serviceDI.loginUseCase
        )
        
        //MARK: MainViewModel
        let mainViewModel = MainViewModel(
            fetchMainUseCase: serviceDI.fetchMainUseCase,
            fetchSimpleProfileUseCase: serviceDI.fetchSimpleUseCase,
            classroomReturnUseCase: serviceDI.classroomReturn,
            fetchTodayTimeTableUseCase: serviceDI.fetchTodayTimeTableUseCase,
            fetchSchoolMealUseCase: serviceDI.fetchSchoolMealUseCase,
            fetchNoticeListUseCase: serviceDI.fetchNoticeListUseCase
        )
        
        //MARK: 신청 ViewModel
        let applyViewModel = ApplyViewModel(
            weekendMealCheckUseCase: serviceDI.weekendMealCheckUseCase,
            weekendMealApplyUseCase: serviceDI.weekendMealApplyUseCase
        )
        
        let outingViewModel = OutingApplyViewModel(
            outingApplyUseCase: serviceDI.outingApplyUseCase
        )
        
        let outingPassViewModel = OutingPassViewModel(
            fetchOutingPassUseCase: serviceDI.fetchOutingPassUseCase,
            fetchEarlyLeavePassUseCase: serviceDI.fetchEarlyLeavePassUseCase
        )
        
        let earlyLeaveViewModel = EarlyLeaveApplyViewModel(
            earlyLeaveApplyUseCase: serviceDI.earlyLeaveUseCase
        )
        
        let classroomViewModel = ClassroomMoveApplyViewModel(
            classroomMoveApplyUseCase: serviceDI.classroomMoveUseCase
        )
        
        //MARK: ProfileViewModel
        let profileViewModel = ProfileViewModel(
            fetchDetailProfileUseCase: serviceDI.fetchDetailUseCase
        )
        
        //MARK: SelfStudyTeacherViewModel
        let selfStudyTeacherViewModel = SelfStudyTeacherViewModel(
            fetchSelfStudyTeacherUseCase: serviceDI.fetchSelfStudyTeacherUseCase
        )
        
        //MARK: 공지 ViewModel
        let noticeListViewModel = NoticeListViewModel(
            fetchNoticeListUseCase: serviceDI.fetchNoticeListUseCase
        )
        
        let detailNoticeViewModel = DetailNoticeViewModel(
            fetchDetailNoticeUseCase: serviceDI.fetchDetailNoticeUseCase
        )
        
        //MARK: 일정 ViewModel
        let scheduleViewModel = ScheduleViewModel(
            fetchMonthAcademicSchduleUseCase: serviceDI.fetchMonthAcademicScheduleUseCase,
            fetchWeekTimeTableUseCase: serviceDI.fetchWeekTimeTableUseCase
        )
        
        //MARK: 급식 관련 ViewModel
        let schoolMealViewModel = SchoolMealViewModel(
            fetchSchoolMealUseCase: serviceDI.fetchSchoolMealUseCase
        )
        
        return .init(
            onboardingViewModel: onboardingViewModel,
            loginViewModel: loginViewModel,
            mainViewModel: mainViewModel,
            applyViewModel: applyViewModel,
            profileViewModel: profileViewModel,
            outingViewModel: outingViewModel,
            outingPassViewModel: outingPassViewModel,
            earlyLeaveViewModel: earlyLeaveViewModel,
            classroomMoveViewModel: classroomViewModel,
            selfStudyTeacherViewModel: selfStudyTeacherViewModel,
            noticeListViewModel: noticeListViewModel, 
            detailNoticeViewModel: detailNoticeViewModel, 
            scheduleViewModel: scheduleViewModel,
            schoolMealViewModel: schoolMealViewModel
        )
    }
    
}
