import UIKit

import RxFlow

import Core
import DesignSystem
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
            case .logoutAlertRequired:
                return presentLogoutAlert()
            default:
                return .none
        }
    }

    private func navigateToProfile() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController//.viewModel
        ))
    }
    
    private func presentLogoutAlert() -> FlowContributors {
        let logoutAlert = PiCKAlert(
            questionText: "정말 로그아웃 하시겠습니까?",
            cancelButtonTitle: "아니요",
            checkButtonTitle: "예",
            clickToAction: {
                print("로그아웃")
            })
        logoutAlert.modalPresentationStyle = .overFullScreen
        logoutAlert.modalTransitionStyle = .crossDissolve
        rootViewController.present(logoutAlert, animated: true)
        return .none
    }

}
