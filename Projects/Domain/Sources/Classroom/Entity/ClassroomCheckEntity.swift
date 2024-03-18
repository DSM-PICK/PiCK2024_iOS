import Foundation

public struct ClassroomCheckEntity {
    public let userName: String
    public let classroom: String
    
    public init(
        userName: String,
        classroom: String
    ) {
        self.userName = userName
        self.classroom = classroom
    }
    
}
