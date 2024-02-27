import UIKit

import Moya

public extension Error {
    func toError<T: BaseError>(_ errorType: T.Type) -> T {
        guard let error = (self as? MoyaError)?.response?.statusCode else { return .UNOWNDEERROR }
        return T.mappingError(rawValue: error)
    }
}
