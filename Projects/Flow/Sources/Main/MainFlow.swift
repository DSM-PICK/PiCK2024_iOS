import UIKit

import RxFlow

import Core
import Presentation

public class MainFlow: Flow {
    
    public var root: Presentable {
        return rootViewController
    }

    private let rootViewController: MainViewController
    private let container = StepperDI.shared
    
    public init() {
        self.rootViewController = MainViewController(viewModel: container.mainViewModel)
    }
    
    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? PiCKStep else { return .none }
        
        switch step {
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
            case .devRequired:
                return presentDevPage()
            default:
                return .none
        }
    }
    
    private func navigateToMain() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel//MARK: 향후에 ViewModel로 변경
        ))
    }
    
    private func navigateToProfile() -> FlowContributors {
        let profileFlow = ProfileFlow()
        Flows.use(profileFlow, when: .created) { [weak self] root in
            self?.rootViewController.navigationController?.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: profileFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.profileRequired)
        ))
    }
    
    private func navigateToSchedule() -> FlowContributors {
        let scheduleFlow = ScheduleFlow()
        Flows.use(scheduleFlow, when: .created) { [weak self] root in
            self?.rootViewController.navigationController?.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: scheduleFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.scheduleRequired)
        ))
    }
    
    private func navigateToApply() -> FlowContributors {
        let applyFlow = ApplyFlow()
        Flows.use(applyFlow, when: .created) { [weak self] root in
            self?.rootViewController.navigationController?.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: applyFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.applyRequired)
        ))
    }
    
    private func navigateToSchoolMeal() -> FlowContributors {
        let schoolMealFlow = SchoolMealFlow()
        Flows.use(schoolMealFlow, when: .created) { [weak self] root in
            self?.rootViewController.navigationController?.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: schoolMealFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.schoolMealRequired)
        ))
    }
    
    private func navigateToSelfStudyTeacher() -> FlowContributors {
        let noticeFlow = SelfStudyTeacherFlow()
        Flows.use(noticeFlow, when: .created) { [weak self] root in
            self?.rootViewController.navigationController?.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: noticeFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.selfStudyTeacherRequired)
        ))
    }
    
    private func presentOutingPass() -> FlowContributors {
        let viewModel = OutingPassViewModel()
        let viewController = OutingPassViewController(viewModel: viewModel)
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewController
        ))
    }
    
    private func navigateToNotice() -> FlowContributors {
        let noticeFlow = NoticeFlow()
        Flows.use(noticeFlow, when: .created) { [weak self] root in
            self?.rootViewController.navigationController?.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: noticeFlow,
            withNextStepper: OneStepper(withSingleStep: PiCKStep.noticeRequired)
        ))
    }
    
    private func presentDevPage() -> FlowContributors {
        let vc = DevVC()
        self.rootViewController.navigationController?.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    
}
