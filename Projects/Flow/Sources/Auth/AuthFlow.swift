import UIKit
import RxFlow
import Core
import Presentation

public class AuthFlow: Flow {
    
    public var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PickStep else { return .none }
        
        switch step {
            case .loginRequired:
                return navigateToLogin()
            default:
                return .none
        }
    }
    
    private func navigateToLogin() -> FlowContributors {
        let loginViewController = LoginViewController()
        self.rootViewController.pushViewController(loginViewController, animated: true)
        return .none
    }
    
}
