import UIKit

import RxFlow

import Core
import Presentation

public class LoginFlow: Flow {
    
    public init() {}
    
    public var root: Presentable {
        return rootPresentable
    }

    private let rootPresentable = BaseNavigationController()

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
        let viewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: viewModel)
        self.rootPresentable.pushViewController(loginViewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: loginViewController,
            withNextStepper: viewModel
        ))
    }
    
    private func navigateToMain() -> FlowContributors {
        let mainFlow = MainFlow()
        Flows.use(mainFlow, when: .created) { [weak self] root in
            self?.rootPresentable.navigationController?.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: mainFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.mainRequired)
        ))
//        let viewModel = MainViewModel()
//        let mainViewController = MainViewController(viewModel: viewModel)
//        self.rootPresentable.pushViewController(mainViewController, animated: true)
//        return .one(flowContributor: .contribute(
//            withNextPresentable: mainViewController,
//            withNextStepper: viewModel
//        ))
    }

}
