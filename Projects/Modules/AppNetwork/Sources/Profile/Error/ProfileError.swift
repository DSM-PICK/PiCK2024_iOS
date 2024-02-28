import Foundation

import Core

public enum ProfileError: Int, BaseError {
    
    case BADREQUEST = 400
    case UNAUTHORIZED = 401
    case FORBIDDEN = 403
    case NOTFOUND = 404
    case BADSERVER = 500
    case UNOWNDEERROR = 0
    
    public static func mappingError(rawValue: Int) -> ProfileError {
        return Self(rawValue: rawValue) ?? .UNOWNDEERROR
    }
}

extension ProfileError {
    public var errorDescription: String? {
        switch self {
            case .BADREQUEST:
                return "올바르지 않은 요청입니다."
            case .UNAUTHORIZED:
                return "유효하지 않은 요청입니다."
            case .FORBIDDEN:
                return "권한 없음."
            case .NOTFOUND:
                return "학생을 찾을 수 없습니다."
            case .BADSERVER:
                return "관리자에게 문의해주세요.\n500"
            default:
                return "알 수 없는 오류입니다.\n에러코드를 확인하세요."
        }
    }
}
