import Foundation

import RxSwift
import RxCocoa
import RxFlow

public enum PiCKStep: Step {
    
    case onBoardingRequired
    case loginRequired
    
    //alert
    case popRequired
    case successAlertRequired(message: String)
    case errorAlertRequired(message: String)
    
    //main
    case mainRequired
    case outingPassRequired
    
    //schedule
    case scheduleRequired
    
    //apply
    case applyRequired
    case classroomMoveApplyRequired
    case outingApplyRequired
    case earlyLeaveApplyRequired
    case timePickerAlertRequired(time: [String])
    
    //schoolMeal
    case schoolMealRequired
    
    //profile
    case profileRequired
    case logoutAlertRequired
    case logoutRequired
    
    //notice
    case noticeRequired
    case detailNoticeRequired(id: UUID)
    
    //selfStudyTeacher
    case selfStudyTeacherRequired
    
    //test
    case testRequired

}
