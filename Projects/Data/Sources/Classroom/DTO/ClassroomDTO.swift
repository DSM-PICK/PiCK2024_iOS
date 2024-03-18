import Foundation

import Domain

public struct ClassroomCheckDTO: Decodable {
    let username: String
    let classroom: String
    
}

extension ClassroomCheckDTO {
    func toDomain() -> ClassroomCheckEntity {
        return .init(
            userName: username,
            classroom: classroom
        )
    }
    
}
