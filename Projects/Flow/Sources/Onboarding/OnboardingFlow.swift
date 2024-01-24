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
        guard let step = step as? PickStep else { return .none }
        
        switch step {
            case .onBoardingRequired:
                return navigateToOnboarding()
            case .loginRequired:
                return navigateToLogin()
        }
    }
    
    private func navigateToOnboarding() -> FlowContributors {
        let onboardingViewController = OnboardingViewController()
        self.rootPresentable.pushViewController(onboardingViewController, animated: false)
        return .one(flowContributor: .contribute(withNext: onboardingViewController))
    }

    private func navigateToLogin() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: PickStep.loginRequired)
    }

}
