import UIKit

import RxFlow

import Core
import Presentation

public class MainFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }
    
    private let rootViewController = BaseNavigationController()
    
    private let container = StepperDI.shared
    
    public init() {}
    
    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
            case .onBoardingRequired:
                return .end(forwardToParentFlowWithStep: PiCKStep.onBoardingRequired)
            case .mainRequired:
                return navigateToMain()
            case .profileRequired:
                return navigateToProfile()
            case .scheduleRequired:
                return navigateToSchedule()
            case .applyRequired:
                return navigateToApply()
            case .schoolMealRequired:
                return navigateToSchoolMeal()
            case .selfStudyTeacherRequired:
                return navigateToSelfStudyTeacher()
            case .outingPassRequired:
                return presentOutingPass()
            case .noticeRequired:
                return navigateToNotice()
            case .detailNoticeRequired(let id):
                return navigateToDetailNotice(id: id)
            default:
                return .none
        }
    }
    
    private func navigateToMain() -> FlowContributors {
        let viewModel = container.mainViewModel
        let viewController = MainViewController(viewModel: viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewController.viewModel
        ))
    }
    
    private func navigateToProfile() -> FlowContributors {
        let profileFlow = ProfileFlow()
        Flows.use(profileFlow, when: .created) { [weak self] root in
            self?.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: profileFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.profileRequired)
        ))
    }
    
    private func navigateToSchedule() -> FlowContributors {
        let scheduleFlow = ScheduleFlow()
        Flows.use(scheduleFlow, when: .created) { [weak self] root in
            self?.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: scheduleFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.scheduleRequired)
        ))
    }
    
    private func navigateToApply() -> FlowContributors {
        let applyFlow = ApplyFlow()
        Flows.use(applyFlow, when: .created) { [weak self] root in
            self?.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: applyFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.applyRequired)
        ))
    }
    
    private func navigateToSchoolMeal() -> FlowContributors {
        let schoolMealFlow = SchoolMealFlow()
        Flows.use(schoolMealFlow, when: .created) { [weak self] root in
            self?.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: schoolMealFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.schoolMealRequired)
        ))
    }
    
    private func navigateToSelfStudyTeacher() -> FlowContributors {
        let noticeFlow = SelfStudyTeacherFlow()
        Flows.use(noticeFlow, when: .created) { [weak self] root in
            self?.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: noticeFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.selfStudyTeacherRequired)
        ))
    }
    
    private func presentOutingPass() -> FlowContributors {
        let viewModel = container.outingPassViewModel
        let viewController = OutingPassViewController(viewModel: viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewModel
        ))
    }
    
    private func navigateToNotice() -> FlowContributors {
        let noticeFlow = NoticeFlow()
        Flows.use(noticeFlow, when: .created) { [weak self] root in
            self?.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: noticeFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.noticeRequired)
        ))
    }
    
    private func navigateToDetailNotice(id: UUID) -> FlowContributors {
        let viewModel = container.detailNoticeViewModel
        let viewController = DetailNoticeViewController(viewModel: viewModel)
        viewController.id = id
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
    
}
