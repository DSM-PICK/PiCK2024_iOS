import Domain

public struct ServiceDI {
    public static let shared = resolve()

    // Auth
    public let loginUseCase: LoginUseCase
    
    //profile
    public let fetchSimpleUseCase: FetchSimpleProfileUseCase
    public let fetchDetailUseCase: FetchDetailProfileUseCase
    
    //outing
    public let outingApplyUseCase: OutingApplyUseCase
    
    //earlyLeave
    public let earlyLeaveUseCase: EarlyLeaveApplyUseCase
    
    //classroom
    public let classroomMoveUseCase: ClassroomMoveApplyUseCase
    
    //weekendMeal
    public let weekendMealCheckUseCase: WeekendMealCheckUseCase
    public let weekendMealApplyUseCase: WeekendMealApplyUseCase
}

extension ServiceDI {
    private static func resolve() -> ServiceDI {
        let authRepo = AuthRepositoryImpl()
        let profileRepo = ProfileRepositoryImpl()
        let outingRepo = OutingRepositoryImpl()
        let earlyLeaveRepo = EarlyLeaveRepositoryImpl()
        let classroomRepo = ClassroomRepositoryImpl()
        let weekendMealRepo = WeekendMealRepositoryImpl()

        //MARK: Auth관련 UseCase
        let loginUseCaseInject = LoginUseCase(
            repository: authRepo
        )
        
        //MARK: Profile관련 UseCase
        let fetchSimpleProfileUseCaseInject = FetchSimpleProfileUseCase(
            repository: profileRepo
        )
        let fetchDetailProfileUseCaseInject = FetchDetailProfileUseCase(
            repository: profileRepo
        )
        
        //MARK: 외출 관련 UseCase
        let outingApplyUseCaseInject = OutingApplyUseCase(
            repository: outingRepo
        )
        
        //MARK: 조기귀가 관련 UseCase
        let earlyLeaveApplyUseCaseInject = EarlyLeaveApplyUseCase(
            repository: earlyLeaveRepo
        )
        
        //MARK: 교실 이동 관련 UseCase
        let classroomMoveApplyUseCaseInject = ClassroomMoveApplyUseCase(
            repository: classroomRepo
        )
        
        //MARK: 주말 급식 관련 UseCase
        let weekendMealCheckUseCaseInject = WeekendMealCheckUseCase(
            repository: weekendMealRepo
        )
        
        let weekendMealApplyUseCaseInject = WeekendMealApplyUseCase(
            repository: weekendMealRepo
        )

        return .init(
            loginUseCase: loginUseCaseInject,
            fetchSimpleUseCase: fetchSimpleProfileUseCaseInject,
            fetchDetailUseCase: fetchDetailProfileUseCaseInject,
            outingApplyUseCase: outingApplyUseCaseInject,
            earlyLeaveUseCase: earlyLeaveApplyUseCaseInject,
            classroomMoveUseCase: classroomMoveApplyUseCaseInject,
            weekendMealCheckUseCase: weekendMealCheckUseCaseInject,
            weekendMealApplyUseCase: weekendMealApplyUseCaseInject
        )
    }
    
}
