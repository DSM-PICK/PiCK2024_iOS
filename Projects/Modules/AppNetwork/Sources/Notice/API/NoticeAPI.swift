import Foundation

import Moya

import Core

public enum NoticeAPI {
    case fetchTodayNoticeList
    case fetchNoticeList
    case fetchDetailNotice(id: UUID)
}

extension NoticeAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .fetchTodayNoticeList:
                return "/notice/today"
            case .fetchNoticeList:
                return "/notice/simple"
            case .fetchDetailNotice(let id):
                return "/notice/\(id)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        return .requestPlain
    }
    
    public var headers: [String : String]? {
        return TokenStorage.shared.toHeader(.accessToken)
    }
    
    
}
