import UIKit

import RxSwift
import RxCocoa
import RxFlow

import Core
import DesignSystem
import Presentation

public class ProfileFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }

    private let rootViewController: ProfileViewController
    private let container = StepperDI.shared
    
    public init() {
        self.rootViewController = ProfileViewController(
            viewModel: container.profileViewModel
        )
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .profileRequired:
                return navigateToProfile()
            case .logoutAlertRequired:
                return presentLogoutAlert()
            case .logoutRequired:
                return logout()
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
    
    private func presentLogoutAlert() -> FlowContributors {
        let logoutAlert = PiCKAlert(
            questionText: "정말 로그아웃 하시겠습니까?",
            cancelButtonTitle: "아니요",
            checkButtonTitle: "예",
            clickToAction: {
            }
        )
        logoutAlert.modalPresentationStyle = .overFullScreen
        logoutAlert.modalTransitionStyle = .crossDissolve
        rootViewController.present(logoutAlert, animated: true)
        return .none
    }
    
    private func logout() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: PiCKStep.loginRequired)
    }

}
