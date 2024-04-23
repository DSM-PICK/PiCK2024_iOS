import Foundation

import Moya

import Core

public enum ScheduelAPI {
    case fetchMonthAcademicSchedule(year: String, month: MonthType.RawValue)
    case fetchTodayTimeTable
    case fetchWeekTimeTable
}

extension ScheduelAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .fetchMonthAcademicSchedule:
                return "/schedule/month"
            case .fetchTodayTimeTable:
                return "/timetable/today"
            case .fetchWeekTimeTable:
                return "/timetable/week"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
            case let .fetchMonthAcademicSchedule(year, month):
                return .requestParameters(
                    parameters: [
                        "year": year,
                        "month": month
                    ],
                    encoding: URLEncoding.queryString
                )
            default:
                return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return TokenStorage.shared.toHeader(.accessToken)
    }
    
    
}
