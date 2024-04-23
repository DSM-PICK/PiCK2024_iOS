import UIKit

import RxFlow

import Core
import DesignSystem
import Presentation

public class ApplyFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }
    
    private let rootViewController: ApplyViewController
    
    private let container = StepperDI.shared
    
    public init() {
        self.rootViewController = ApplyViewController(viewModel: container.applyViewModel)
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
//            case let .timePickerAlertRequired(time):
//                return presentTimePickerAlert(time: time)
            case let .successAlertRequired(message):
                return modal(message: message)
            case .popRequired:
                return popRequired()
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
    
    private func navigateToClassroomMoveApply() -> FlowContributors {
        let viewModel = container.classroomMoveViewModel
        let viewController = ClassroomMoveApplyViewController(viewModel: viewModel)
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewModel
        ))
    }
    
    private func navigateToOutingApply() -> FlowContributors {
        let viewModel = container.outingViewModel
        let viewController = OutingApplyViewController(viewModel: viewModel)
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewModel
        ))
    }
    
    private func navigateToEarlyLeaveApply() -> FlowContributors {
        let viewModel = container.earlyLeaveViewModel
        let viewController = EarlyLeaveApplyViewController(viewModel: viewModel)
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewModel
        ))
    }
    
//    private func presentTimePickerAlert(time: String) -> FlowContributors {
////        var dd = ""
//        let timePickerAlert = PiCKTimePickerAlert(
//            clickToAction: { alertTime in
//                dd = "\(alertTime[0] ?? "") : \(alertTime[1] ?? "")"
//            }
//        )
//        
//        timePickerAlert.modalPresentationStyle = .overFullScreen
//        timePickerAlert.modalTransitionStyle = .crossDissolve
//        rootViewController.present(timePickerAlert, animated: true, completion: {
//            return
//        })
//        return .none
//    }
    
    private func popRequired() -> FlowContributors {
        let mainFlow = MainFlow()
        Flows.use(mainFlow, when: .created) { [weak self] root in
            self?.rootViewController.navigationController?.popToRootViewController(animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: mainFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.mainRequired)
        ))
    }
    
    func modal(message: String) -> FlowContributors {
        let modal = PiCKApplyAlert(
            questionText: message,
            checkButtonTitle: "확인",
            clickToAction: {
                self.rootViewController.navigationController?.popToRootViewController(animated: true)
            })
        modal.modalPresentationStyle = .overFullScreen
        modal.modalTransitionStyle = .crossDissolve
        self.rootViewController.present(modal, animated: true)
        return .none
    }
    
}
