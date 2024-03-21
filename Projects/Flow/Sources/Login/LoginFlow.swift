import UIKit

import RxFlow

import Core
import Presentation

public class LoginFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }

//    private let rootViewController: LoginViewController
    private let rootViewController = BaseNavigationController()
    private let container = StepperDI.shared
    
//    public init() {
//        self.rootViewController = LoginViewController(
//            viewModel: container.loginViewModel
//        )
//    }
    public init() {}

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .loginRequired:
                return navigateToLogin()
            case .mainRequired:
                return navigateToMain()
            default:
                return .none
        }
    }

    private func navigateToLogin() -> FlowContributors {
        let viewModel = container.loginViewModel
        let loginViewController = LoginViewController(viewModel: viewModel)
        return .one(flowContributor: .contribute(
            withNextPresentable: loginViewController,
            withNextStepper: loginViewController.viewModel
        ))
    }
    
    private func navigateToMain() -> FlowContributors {
        let mainFlow = MainFlow()
        Flows.use(mainFlow, when: .created) { [weak self] root in
//            self?.rootViewController.navigationController?.pushViewController(root, animated: true)
            self?.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: mainFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.mainRequired)
        ))
    }

}
