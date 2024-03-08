import UIKit

import RxFlow

import Core
import DesignSystem
import Presentation

public class SelfStudyTeacherFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }

    private let rootViewController: SelfStudyTeacherViewController
    private let container = StepperDI.shared
    
    public init() {
        self.rootViewController = SelfStudyTeacherViewController(viewModel: container.selfStudyTeacherViewModel)
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .selfStudyTeacherRequired:
                return navigateToSelfStudyTeacher()
            default:
                return .none
        }
    }
    
    private func navigateToSelfStudyTeacher() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
        
    }

}
