import UIKit

import RxFlow

import Core
import Presentation

public class ScheduleFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }

    private let rootViewController: ScheduleViewController
    
    let container = StepperDI.shared
    
    public init() {
        self.rootViewController = ScheduleViewController(viewModel: container.scheduleViewModel)
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .scheduleRequired:
                return navigateToschedule()
            default:
                return .none
        }
    }

    private func navigateToschedule() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController
        ))
    }

}
