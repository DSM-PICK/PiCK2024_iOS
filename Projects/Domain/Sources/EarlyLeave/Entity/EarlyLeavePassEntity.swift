import Foundation

import Core

public struct EarlyLeavePassEntity {
    public let userName: String
    public let teacherName: String
    public let startTime: String
    public let endTime: String
    public let reason: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let image: [String]
    public let type: OutingPassType.RawValue
    
    public init(
        userName: String,
        teacherName: String,
        startTime: String,
        endTime: String,
        reason: String,
        grade: Int,
        classNum: Int,
        num: Int,
        image: [String],
        type: OutingPassType.RawValue
    ) {
        self.userName = userName
        self.teacherName = teacherName
        self.startTime = startTime
        self.endTime = endTime
        self.reason = reason
        self.grade = grade
        self.classNum = classNum
        self.num = num
        self.image = image
        self.type = type
    }
}

