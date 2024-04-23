import Foundation

public struct TodayNoticeListEntityElement {
    public let id: UUID
    public let title: String
    public let createAt: String
    
    public init(id: UUID, title: String, createAt: String) {
        self.id = id
        self.title = title
        self.createAt = createAt
    }
}

public typealias TodayNoticeListEntity = [TodayNoticeListEntityElement]
