import Domain
import Data
import Presentation

public struct StepperDI {
    public static let shared = resolve()
    
    public let loginViewModel: LoginViewModel
}

extension StepperDI {
    private static func resolve() -> StepperDI {

        let serviceDI = ServiceDI.shared
        
        // MARK: Auth관련 viewModel
        let loginViewModel = LoginViewModel(
            loginUseCase: serviceDI.loginUseCase
        )
        
        return .init(
            loginViewModel: loginViewModel
        )
    }
    
}
