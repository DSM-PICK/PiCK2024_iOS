import UIKit

import RxFlow

import Core
import Presentation

public class ApplyFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }

    private let rootViewController: ApplyViewController
    
    public init() {
        self.rootViewController = ApplyViewController(viewModel: ApplyViewModel())
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .applyRequired:
                return navigateToApply()
            default:
                return .none
        }
    }

    private func navigateToApply() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

}
