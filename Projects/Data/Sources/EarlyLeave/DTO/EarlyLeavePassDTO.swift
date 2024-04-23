import Foundation

import Core
import Domain

public struct EarlyLeavePassDTO: Decodable {
    let userName: String
    let teacherName: String
    let startTime: String
    let reason: String
    let grade: Int
    let classNum: Int
    let num: Int
    let type: OutingPassType.RawValue
    
    enum CodingKeys: String, CodingKey {
        case reason, grade, num, type
        case userName = "username"
        case teacherName = "teacher_name"
        case startTime = "start_time"
        case classNum = "class_num"
    }
}

extension EarlyLeavePassDTO {
    func toDomain() -> EarlyLeavePassEntity {
        return .init(
            userName: userName,
            teacherName: teacherName,
            startTime: startTime,
            reason: reason,
            grade: grade,
            classNum: classNum,
            num: num,
            type: type
        )
    }
    
}
