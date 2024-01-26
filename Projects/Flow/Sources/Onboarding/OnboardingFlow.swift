import UIKit

import RxFlow

import Core
import Presentation

public class OnboardingFlow: Flow {
    
    public init() {}
    
    public var root: Presentable {
        return rootPresentable
    }

    private lazy var rootPresentable = BaseNavigationController()
    
    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .onBoardingRequired:
                return navigateToOnboarding()
            case .loginRequired:
                return navigateToLogin()
            default:
                return .none
        }
    }
    
    private func navigateToOnboarding() -> FlowContributors {
        let onboardingViewController = OnboardingViewController()
        self.rootPresentable.pushViewController(onboardingViewController, animated: true)
        return .one(flowContributor: .contribute(withNext: onboardingViewController))
    }

    private func navigateToLogin() -> FlowContributors {
        let loginViewController = LoginViewController(viewModel: LoginViewModel())
        self.rootPresentable.pushViewController(loginViewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: loginViewController,
            withNextStepper: LoginViewModel()
        ))
    }

}
