import Foundation

import Domain

public struct TodayNoticeDTOElement: Decodable {
    let id: UUID
    let title: String
    let createAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case createAt = "create_at"
    }
    
}

extension TodayNoticeDTOElement {
    func toDomain() -> TodayNoticeListEntityElement {
        return .init(
            id: id,
            title: title,
            createAt: createAt
        )
    }
    
}


public typealias TodayNoticeDTO = [TodayNoticeDTOElement]

extension TodayNoticeDTO {
    func toDomain() -> TodayNoticeListEntity {
        return self.map { $0.toDomain() }
    }
}
