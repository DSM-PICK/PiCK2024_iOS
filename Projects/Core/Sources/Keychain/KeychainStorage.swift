import Foundation
import KeychainSwift

protocol StorageType {
    var key: String { get }
}

public enum UserStorageType: StorageType {
    case id, password

    var key: String {
        switch self {
        case .id: return "userID"
        case .password: return "userPassword"
        }
    }
}

public class KeychainStorage {
    public static let shared = KeychainStorage()
    private let keyChain = KeychainSwift()
 
    public var id: String? {
        set {
            keyChain.set(newValue ?? "", forKey: UserStorageType.id.key)
        }
        get {
            keyChain.get(UserStorageType.id.key)
        }
    }
    
    public var password: String? {
        set {
            keyChain.set(newValue ?? "", forKey: UserStorageType.password.key)
        } get {
            keyChain.get(UserStorageType.password.key)
        }
    }
    
    public func removeKeychain() {
        self.id = ""
        self.password = ""
    }
    
}
