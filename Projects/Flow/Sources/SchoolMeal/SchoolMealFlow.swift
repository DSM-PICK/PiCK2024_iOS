import UIKit

import RxFlow

import Core
import Presentation

public class SchoolMealFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }

    private let rootViewController: SchoolMealViewController
    
    private let container = StepperDI.shared
    
    public init() {
        self.rootViewController = SchoolMealViewController(
            viewModel: container.schoolMealViewModel
        )
    }

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .schoolMealRequired:
                return navigateToSchoolMeal()
            default:
                return .none
        }
    }

    private func navigateToSchoolMeal() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

}
