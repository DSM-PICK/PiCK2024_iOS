import Foundation

import Moya

import Core

public enum SelfStudyTeacherAPI {
    case fetchSelfstudyTeacherCheck(date: String)
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
            case .fetchSelfstudyTeacherCheck(let date):
                return .requestParameters(
                    parameters: ["date": date],
                    encoding: URLEncoding.queryString
                )
        }
    }
    
    public var headers: [String : String]? {
        switch self {
            case .fetchSelfstudyTeacherCheck:
                return TokenStorage.shared.toHeader(.accessToken)
        }
    }
    
    
}
