import Foundation

import Moya

import Core

public enum ClassroomAPI {
    case classroomMoveApply(floor: Int, classroom: String)
    case classroomReturn
    case classroomCheck
}

extension ClassroomAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .classroomMoveApply, .classroomCheck:
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
            case .classroomCheck:
                return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case let .classroomMoveApply(floor, classroom):
                return .requestParameters(
                    parameters: [
                        "floor": floor,
                        "classroom_name": classroom
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

