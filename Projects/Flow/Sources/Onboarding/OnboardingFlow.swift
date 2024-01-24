import UIKit
import RxFlow
import Core
import Presentation

public class OnboardingFlow: Flow {
    
    public init() {}
    
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
            case .onBoardingRequired:
                return navigateToOnboarding()
            default:
                return .none
        }
    }
    
    private func navigateToOnboarding() -> FlowContributors {
        let onboardingViewController = OnboardingViewController()
        rootViewController.pushViewController(onboardingViewController, animated: true)
        return .none
    }
    
}
