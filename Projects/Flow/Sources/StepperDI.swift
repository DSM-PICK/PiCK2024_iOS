import Domain
import Data
import Presentation

public struct StepperDI {
    public static let shared = resolve()
    
    public let loginViewModel: LoginViewModel
    public let mainViewModel: MainViewModel
    public let applyViewModel: ApplyViewModel
    public let profileViewModel: ProfileViewModel
    public let outingViewModel: OutingApplyViewModel
    public let earlyLeaveViewModel: EarlyLeaveApplyViewModel
    public let classroomMoveViewModel: ClassroomMoveApplyViewModel
}

extension StepperDI {
    private static func resolve() -> StepperDI {

        let serviceDI = ServiceDI.shared
        
        //MARK: LoginViewModel
        let loginViewModel = LoginViewModel(
            loginUseCase: serviceDI.loginUseCase
        )
        
        //MARK: MainViewModel
        let mainViewModel = MainViewModel(
            fetchSimpleProfileUseCase: serviceDI.fetchSimpleUseCase
        )
        
        let applyViewModel = ApplyViewModel(
            weekendMealCheckUseCase: serviceDI.weekendMealCheckUseCase,
            weekendMealApplyUseCase: serviceDI.weekendMealApplyUseCase
        )
        
        //MARK: ProfileViewModel
        let profileViewModel = ProfileViewModel(
            fetchDetailProfileUseCase: serviceDI.fetchDetailUseCase
        )
        
        //MARK: OutingViewModel
        let outingViewModel = OutingApplyViewModel(
            outingApplyUseCase: serviceDI.outingApplyUseCase
        )
        
        //MARK: EarlyLeaveViewModel
        let earlyLeaveViewModel = EarlyLeaveApplyViewModel(
            earlyLeaveApplyUseCase: serviceDI.earlyLeaveUseCase
        )
        
        //MARK: ClassroomViewModel
        let classroomViewModel = ClassroomMoveApplyViewModel(
            classroomMoveApplyUseCase: serviceDI.classroomMoveUseCase
        )
        
        return .init(
            loginViewModel: loginViewModel,
            mainViewModel: mainViewModel, 
            applyViewModel: applyViewModel,
            profileViewModel: profileViewModel,
            outingViewModel: outingViewModel,
            earlyLeaveViewModel: earlyLeaveViewModel,
            classroomMoveViewModel: classroomViewModel
        )
    }
    
}
