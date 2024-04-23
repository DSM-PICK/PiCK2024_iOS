import Foundation
import KeychainSwift

public enum TokenType {
    case accessToken, refreshToken, tokenIsEmpty

    var tokenKey: String {
        switch self {
        case .accessToken:
            return "access_token"
        case .refreshToken:
            return "refresh_token"
        default:
            return ""
        }
    }
}

public class TokenStorage {
    public static let shared = TokenStorage()
    private let keyChain = KeychainSwift()

    public var accessToken: String? {
        set {
            keyChain.set(newValue ?? "", forKey: TokenType.accessToken.tokenKey)
        }
        get {
            keyChain.get(TokenType.accessToken.tokenKey)
        }
    }

    public var refreshToken: String? {
        set {
            keyChain.set(newValue ?? "", forKey: TokenType.refreshToken.tokenKey)
        }
        get {
            keyChain.get(TokenType.refreshToken.tokenKey)
        }
    }

    public func toHeader(_ tokenType: TokenType) -> [String: String] {
        guard let accessToken = self.accessToken,
              let refreshToken = self.refreshToken
        else {
            return ["content-type": "application/json"]
        }

        switch tokenType {
        case .accessToken:
            return [
                "content-type": "application/json",
                "Authorization": accessToken
            ]
        case .refreshToken:
            return [
                "content-type": "application/json",
                "X-Refresh-Token": refreshToken
            ]
        case .tokenIsEmpty:
            return ["content-type": "application/json"]
        }
    }

    public func removeToken() {
        self.accessToken = nil
        self.refreshToken = nil
    }
}
