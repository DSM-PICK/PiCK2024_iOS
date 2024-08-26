import Foundation

import Moya

import Core

public enum OutingAPI {
    case outingApply(reason: String, startTime: String, endTime: String)
    case fetchOutingPass
    case earlyLeaveApply(reason: String, startTime: String)
    case fetchEarlyLeavePass
}

extension OutingAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
        case .outingApply:
            return "/application"
        case .fetchOutingPass:
            return "/application/my"
        case .earlyLeaveApply:
            return "/early-return/create"
        case .fetchEarlyLeavePass:
            return "/early-return/my"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .outingApply:
            return .post
        case .earlyLeaveApply:
            return .post
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .outingApply(reason, startTime, endTime):
            return .requestParameters(
                parameters: [
                    "reason": reason,
                    "start_time": startTime,
                    "end_time": endTime
                ],
                encoding: JSONEncoding.default
            )
        case let .earlyLeaveApply(reason, startTime):
            return .requestParameters(
                parameters: [
                    "reason": reason,
                    "start": startTime
                ],
                encoding: JSONEncoding.default
            )
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return TokenStorage.shared.toHeader(.accessToken)
    }
    
    
}
