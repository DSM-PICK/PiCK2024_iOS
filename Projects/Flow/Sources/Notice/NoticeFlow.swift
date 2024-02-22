import UIKit

import RxFlow

import Core
import Presentation

public class NoticeFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }
    
    private let rootViewController: NoticeListViewController
    
    public init() {
        self.rootViewController = NoticeListViewController(viewModel: NoticeListViewModel())
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .noticeRequired:
                return navigateTosNotice()
            case .detailNoticeRequired:
                return navigateToDetailNotice()
            default:
                return .none
        }
    }
    private func navigateTosNotice() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController//MARK: 향후에 ViewModel로 변경
        ))
    }
    
    private func navigateToDetailNotice() -> FlowContributors {
        let viewModel = DetailNoticeViewModel()
        let viewController = DetailNoticeViewController(viewModel: viewModel)
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .none
    }

}
