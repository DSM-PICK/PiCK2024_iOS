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
    private let container = StepperDI.shared
    
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
        let viewModel = container.onboardingViewModel
        let onboardingViewController = OnboardingViewController(
            viewModel: viewModel
        )
        self.rootViewController.pushViewController(onboardingViewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: onboardingViewController,
            withNextStepper: onboardingViewController.viewModel
        ))
    }

    private func navigateToLogin() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: PiCKStep.loginRequired)
    }

}
