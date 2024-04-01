import Foundation

public struct MainEntity {
    public let userID: UUID?
    public let userName: String?
    public let startTime: String?
    public let endTime: String?
    public let classroom: String?
    
    public init(
        userID: UUID?,
        userName: String?,
        startTime: String?,
        endTime: String?,
        classroom: String?
    ) {
        self.userID = userID
        self.userName = userName
        self.startTime = startTime
        self.endTime = endTime
        self.classroom = classroom
    }
    
}
