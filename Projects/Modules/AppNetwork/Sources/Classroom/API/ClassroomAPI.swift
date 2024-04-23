import Foundation

import Moya

import Core

public enum ClassroomAPI {
    case classroomMoveApply(floor: Int, classroom: String, startPeriod: Int, endPeriod: Int)
    case classroomReturn
}

extension ClassroomAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .classroomMoveApply:
                return "/class-room/move"
            case .classroomReturn:
                return "/class-room/return"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .classroomMoveApply:
                return .post
            case .classroomReturn:
                return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case let .classroomMoveApply(floor, classroom, startPeriod, endPeriod):
                return .requestParameters(
                    parameters: [
                        "floor": floor,
                        "classroom_name": classroom,
                        "start_period": startPeriod,
                        "end_period": endPeriod
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

