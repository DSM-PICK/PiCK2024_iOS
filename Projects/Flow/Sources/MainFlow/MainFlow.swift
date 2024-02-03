import UIKit

import RxFlow

import Core
import Presentation

public class MainFlow: Flow {
    
    public init() {}
    
    public var root: Presentable {
        return rootPresentable
    }

    private let rootPresentable = BaseNavigationController()
    
    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .mainRequired:
                return navigateToMain()
            default:
                return .none
        }
    }
    
    private func navigateToMain() -> FlowContributors {
        let viewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: viewModel)
        self.rootPresentable.navigationController?.pushViewController(mainViewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: mainViewController,
            withNextStepper: viewModel
        ))
    }

}
