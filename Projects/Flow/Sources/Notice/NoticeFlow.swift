import UIKit

import RxFlow

import Core
import Presentation

public class NoticeFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }
    
    private let rootViewController: NoticeListViewController
    
    let container = StepperDI.shared
    
    public init() {
        self.rootViewController = NoticeListViewController(
            viewModel: container.noticeListViewModel
        )
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .noticeRequired:
                return navigateTosNotice()
            case .detailNoticeRequired(let id):
                return navigateToDetailNotice(id: id)
            default:
                return .none
        }
    }
    private func navigateTosNotice() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
    
    private func navigateToDetailNotice(id: UUID) -> FlowContributors {
        let viewModel = container.detailNoticeViewModel
        let viewController = DetailNoticeViewController(viewModel: viewModel)
        viewController.id = id
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .none
    }

}
