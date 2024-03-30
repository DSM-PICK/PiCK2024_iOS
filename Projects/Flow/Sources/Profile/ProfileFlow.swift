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
            case .logoutRequired:
                return .end(forwardToParentFlowWithStep: PiCKStep.onBoardingRequired)
//                return logout()
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
    
//    private func presentLogoutAlert() -> FlowContributors {
//        let logoutAlert = PiCKAlert(
//            questionText: "정말 로그아웃 하시겠습니까?",
//            cancelButtonTitle: "아니요",
//            checkButtonTitle: "예",
//            clickToAction: {
//                print("fjdskl")
//            }
//        )
//        logoutAlert.modalPresentationStyle = .overFullScreen
//        logoutAlert.modalTransitionStyle = .crossDissolve
//        rootViewController.present(logoutAlert, animated: true)
//        return .none
//    }
    
//    private func logout() -> FlowContributors {
////        let dd = OnboardingViewController(viewModel: container.onboardingViewModel)
////            UIView.transition(
////                with: self.rootViewController.view.window!,
////                duration: 0.5,
////                options: .transitionCrossDissolve) {
//////                    self.rootViewController.dismiss(animated: true)
//////                    self.rootViewController.navigationController?.popToViewController(dd, animated: true)
////                }
//        let schoolMealFlow = LoginFlow()
//        Flows.use(schoolMealFlow, when: .created) { [weak self] root in
//            self?.rootViewController.pushViewController(root, animated: true)
//        }
//        
//        return .one(flowContributor: .contribute(
//            withNextPresentable: schoolMealFlow,
//            withNextStepper: OneStepper(withSingleStep: PiCKStep.loginRequired)
//        ))
//        return .one(flowContributor: .contribute(
//            withNextPresentable: loginFlow,
//            withNextStepper: OneStepper(withSingleStep: PiCKStep.loginRequired)
//        ))
//        return .end(forwardToParentFlowWithStep: PiCKStep.loginRequired)

//    }

}
