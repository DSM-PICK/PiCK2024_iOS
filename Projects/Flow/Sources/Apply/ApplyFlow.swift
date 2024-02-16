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
            case .classroomMoveApplyRequired:
                return navigateToClassroomMoveApply()
            case .outingApplyRequired:
                return navigateToOutingApply()
            case .earlyLeaveApplyRequired:
                return navigateToEarlyLeaveApply()
            default:
                return .none
        }
    }

    private func navigateToApply() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController
        ))
    }
    
    private func navigateToClassroomMoveApply() -> FlowContributors {
        let viewModel = ClassroomMoveApplyViewModel()
        let viewController = ClassroomMoveApplyViewController(viewModel: viewModel)
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewModel
        ))
    }
    private func navigateToOutingApply() -> FlowContributors {
        let viewModel = OutingApplyViewModel()
        let viewController = OutingApplyViewController(viewModel: viewModel)
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewModel
        ))
    }
    private func navigateToEarlyLeaveApply() -> FlowContributors {
        let viewModel = EarlyLeaveApplyViewModel()
        let viewController = EarlyLeaveApplyViewController(viewModel: viewModel)
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewModel
        ))
    }

}
