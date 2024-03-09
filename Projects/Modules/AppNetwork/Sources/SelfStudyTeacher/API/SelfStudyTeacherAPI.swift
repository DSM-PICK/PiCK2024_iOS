import Foundation

import Moya

import Core

public enum SelfStudyTeacherAPI {
    case fetchSelfstudyTeacherCheck
}

extension SelfStudyTeacherAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .fetchSelfstudyTeacherCheck:
                return "/self-study/today"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .fetchSelfstudyTeacherCheck:
                return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case .fetchSelfstudyTeacherCheck:
                return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
            case .fetchSelfstudyTeacherCheck:
                return TokenStorage.shared.toHeader(.accessToken)
        }
    }
    
    
}
