import Foundation

import Moya

import Core

public enum MainAPI {
    case fetchMainData
}

extension MainAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .fetchMainData:
                return "/main"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .fetchMainData:
                return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case .fetchMainData:
                return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
            case .fetchMainData:
                return TokenStorage.shared.toHeader(.accessToken)
        }
    }
    
    
}
