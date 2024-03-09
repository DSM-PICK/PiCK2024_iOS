import Foundation

import Moya

import Core

public enum ScheduelAPI {
    case fetchMonthAcademicSchedule(month: Int)
    case fetchTimeTable(date: MonthType.RawValue)
}

extension ScheduelAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .fetchMonthAcademicSchedule(let month):
                return "/schedule/month=\(month)"
            case .fetchTimeTable(let date):
                return "/calendar/\(date)"
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
