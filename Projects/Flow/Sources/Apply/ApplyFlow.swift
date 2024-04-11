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
            case .timePickerAlertRequired(let button):
                return presentTimePickerAlert(button)
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
    
    private func presentTimePickerAlert(_ button: [String]) -> FlowContributors {
        let timePickerAlert = PiCKTimePickerAlert(clickToAction: { depatureTime in
            //            button.setTitle("\(depatureTime[0] ?? "") : \(depatureTime[1] ?? "")", for: .normal)
            //            button.setTitleColor(.neutral50, for: .normal)
        })
        timePickerAlert.modalPresentationStyle = .overFullScreen
        timePickerAlert.modalTransitionStyle = .crossDissolve
        rootViewController.present(timePickerAlert, animated: true)
        return .none
    }
    
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
        let modal = PiCKAlert(
            questionText: message,
            cancelButtonTitle: "취소",
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
