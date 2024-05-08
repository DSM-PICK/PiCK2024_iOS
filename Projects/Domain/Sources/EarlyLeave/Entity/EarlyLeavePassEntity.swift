import Foundation

import Core

public struct EarlyLeavePassEntity {
    public let userName: String
    public let teacherName: String
    public let startTime: String
    public let reason: String
    public let schoolNum: Int
    public let type: OutingPassType.RawValue
    
    public init(
        userName: String,
        teacherName: String,
        startTime: String,
        reason: String,
        schoolNum: Int,
        type: OutingPassType.RawValue
    ) {
        self.userName = userName
        self.teacherName = teacherName
        self.startTime = startTime
        self.reason = reason
        self.schoolNum = schoolNum
        self.type = type
    }
    
}

