import Foundation

import Moya

import Core

public enum AuthAPI {
    case login(accountID: String, password: String)
    case refreshToken
}

extension AuthAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }
    
    public var path: String {
        switch self {
            case .login:
                return "/user/login"
            case .refreshToken:
                return "/user/refresh"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .login:
                return .post
            case .refreshToken:
                return .put
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case let .login(accountID, password):
                return .requestParameters(
                    parameters: [
                        "account_id": accountID,
                        "password": password
                    ],
                    encoding: JSONEncoding.default
                )
                
            case .refreshToken:
                return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
            case .login:
                return TokenStorage.shared.toHeader(.tokenIsEmpty)
            case .refreshToken:
                return TokenStorage.shared.toHeader(.refreshToken)
        }
    }
    
    
}
