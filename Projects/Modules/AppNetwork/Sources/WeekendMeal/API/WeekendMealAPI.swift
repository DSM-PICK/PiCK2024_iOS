import Foundation

import Moya

import Core

public enum WeekendMealAPI {
    case weekendMealApply(status: WeekendMealTypeEnum.RawValue)
    case weekendMealCheck
}

extension WeekendMealAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .weekendMealApply:
                return "/weekend-meal/status"
            case .weekendMealCheck:
                return "/weekend-meal/my"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .weekendMealApply:
                return .patch
            case .weekendMealCheck:
                return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case .weekendMealApply(let status):
                return .requestParameters(
                    parameters: ["status": status],
                    encoding: URLEncoding.queryString
                )
            case .weekendMealCheck:
                return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return TokenStorage.shared.toHeader(.accessToken)
    }
    
    
}

