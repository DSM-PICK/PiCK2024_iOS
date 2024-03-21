import UIKit

import RxFlow

import Core

public class AppFlow: Flow {
    
    private var window: UIWindow
    
    public var root: RxFlow.Presentable {
        return window
    }
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .onBoardingRequired:
                return presentOnboardingView()
            case .loginRequired:
                return presentLoginView()
            case .mainRequired:
                return presentMainView()
            case .testRequired:
                return presentTestView()
            default:
                return .none
        }
    }
    
    private func presentOnboardingView() -> FlowContributors {
        let onboardingFlow = OnboardingFlow()
        Flows.use(onboardingFlow, when: .created) { [weak self] root in
            self?.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: onboardingFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.onBoardingRequired)
        ))
    }
    
    private func presentLoginView() -> FlowContributors {
        let loginFlow = LoginFlow()
        Flows.use(loginFlow, when: .created) { [weak self] root in
            self?.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: loginFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.loginRequired)
        ))
    }
    
    private func presentMainView() -> FlowContributors {
        let mainFlow = MainFlow()
        Flows.use(mainFlow, when: .created) { [weak self] root in
            self?.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: mainFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.mainRequired)
        ))
    }
    
    private func presentTestView() -> FlowContributors {
        let testFlow = TestFlow()
        Flows.use(testFlow, when: .created) { [weak self] root in
            self?.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: testFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.testRequired)
        ))
    }
    
}
