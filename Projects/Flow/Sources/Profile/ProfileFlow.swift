import UIKit

import RxFlow

import Core
import Presentation

public class ProfileFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }

    private let rootViewController: ProfileViewController
    
    public init() {
        self.rootViewController = ProfileViewController(viewModel: ProfileViewModel())
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .profileRequired:
                return navigateToProfile()
            default:
                return .none
        }
    }

    private func navigateToProfile() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

}
