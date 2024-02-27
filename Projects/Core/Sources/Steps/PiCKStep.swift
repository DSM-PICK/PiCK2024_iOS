import RxFlow

public enum PiCKStep: Step {
    
    case onBoardingRequired
    case loginRequired
    
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
    case detailNoticeRequired
    
    //teacherInquiry
    case teacherInquiryRequired
    
    //test
    case testRequired

}
