import Foundation

import Moya

import Core

public enum EarlyLeaveAPI {
    case earlyLeaveApply(reason: String, startTime: String)
    case fetchEarlyLeavePass
}

extension EarlyLeaveAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .earlyLeaveApply:
                return "/early-return/create"
            case .fetchEarlyLeavePass:
                return "/early-return/my"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .earlyLeaveApply:
                return .post
            case .fetchEarlyLeavePass:
                return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case let .earlyLeaveApply(reason, startTime):
                return .requestParameters(
                    parameters: [
                        "reason": reason,
                        "start_time": startTime
                    ],
                    encoding: JSONEncoding.default
                )
            case .fetchEarlyLeavePass:
                return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return TokenStorage.shared.toHeader(.accessToken)
    }
    
    
}
