import Foundation

import Moya

import Core

public enum ProfileAPI {
    case fetchSimpleProfile
    case fetchDetailProfile
}

extension ProfileAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .fetchSimpleProfile:
                return "/user/simple"
            case .fetchDetailProfile:
                return "/user/details"
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
