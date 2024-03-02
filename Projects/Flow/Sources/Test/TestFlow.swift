import UIKit

import RxFlow

import Core
import Presentation

public class TestFlow: Flow {
    
    public init() {}
    
    public var root: Presentable {
        return rootPresentable
    }

    private let rootPresentable = BaseNavigationController()
    private let container = StepperDI.shared
    
    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .testRequired:
                return navigateToTest()
            default:
                return .none
        }
    }
    
    private func navigateToTest() -> FlowContributors {
        let viewModel = container.applyViewModel
        let viewController = ApplyViewController(viewModel: viewModel)
        self.rootPresentable.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewModel
        ))
    }

}
