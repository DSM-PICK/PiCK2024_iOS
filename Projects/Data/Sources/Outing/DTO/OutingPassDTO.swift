import Foundation

import Core
import Domain

public struct OutingPassDTO: Decodable {
    let userName: String
    let teacherName: String
    let startTime: String
    let endTime: String
    let reason: String
    let grade: Int
    let classNum: Int
    let num: Int
    let image: String
    let type: OutingPassType.RawValue
    
    enum CodingKeys: String, CodingKey {
        case reason, grade, num, image, type
        case userName = "username"
        case teacherName = "teacher_name"
        case startTime = "start_time"
        case endTime = "end_time"
        case classNum = "class_num"
    }
}

extension OutingPassDTO {
    func toDomain() -> OutingPassEntity {
        return .init(
            userName: userName,
            teacherName: teacherName,
            startTime: startTime,
            endTime: endTime,
            reason: reason,
            grade: grade,
            classNum: classNum,
            num: num,
            image: image,
            type: type
        )
    }
    
}
