import UIKit

import RxFlow

import Core
import Presentation

public class OnboardingFlow: Flow {
    
    public init() {}
    
    public var root: Presentable {
        return rootViewController
    }

    private var rootViewController = BaseNavigationController()
    
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
        self.rootViewController.pushViewController(onboardingViewController, animated: true)
        return .one(flowContributor: .contribute(withNext: onboardingViewController))
    }

    private func navigateToLogin() -> FlowContributors {
        let loginFlow = LoginFlow()
        Flows.use(loginFlow, when: .created) { [weak self] root in
            self?.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: loginFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.loginRequired)
        ))
    }

}
