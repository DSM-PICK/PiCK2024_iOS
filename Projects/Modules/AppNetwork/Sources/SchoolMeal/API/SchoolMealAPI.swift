import Foundation

import Moya

import Core

public enum SchoolMealAPI {
    case fetchSchoolMeal(date: String)
}

extension SchoolMealAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .fetchSchoolMeal:
                return "/meal/date"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
            case .fetchSchoolMeal(let date):
                return .requestParameters(
                    parameters: ["date": date],
                    encoding: URLEncoding.queryString
                )
        }
    }
    
    public var headers: [String : String]? {
        return TokenStorage.shared.toHeader(.accessToken)
    }
    
    
}

