import UIKit

import RxFlow

import Core
import Presentation

public class LoginFlow: Flow {
    
    public init() {}
    
    public var root: Presentable {
        return rootPresentable
    }

    private lazy var rootPresentable = BaseNavigationController()

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .loginRequired:
                return navigateToLogin()
            case .onBoardingRequired:
                return navigateToOnboarding()
        }
    }

    private func navigateToLogin() -> FlowContributors {
        let loginViewController = LoginViewController()
        self.rootPresentable.pushViewController(loginViewController, animated: false)
        return .one(flowContributor: .contribute(withNext: loginViewController))
    }

    private func navigateToOnboarding() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: PiCKStep.onBoardingRequired)
    }

}
