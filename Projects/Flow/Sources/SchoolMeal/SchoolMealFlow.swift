import UIKit

import RxFlow

import Core
import Presentation

public class SchoolMealFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }

    private let rootViewController: SchoolMealViewController
    
    public init() {
        self.rootViewController = SchoolMealViewController(viewModel: SchoolMealViewModel())
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
//        return .one(flowContributor: .contribute(
//            withNextPresentable: rootViewController,
//            withNextStepper: rootViewController.viewModel
//        ))
        return .one(flowContributor: .contribute(withNext: rootViewController))
    }

}
