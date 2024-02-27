import Foundation

public protocol BaseError: Error, LocalizedError {
    static var UNOWNDEERROR: Self { get }

    static func mappingError(rawValue: Int) -> Self
}

extension BaseError where Self: RawRepresentable, Self.RawValue == Int {
    func mappingError(rawValue: Int) -> Self {
        return Self(rawValue: rawValue) ?? .UNOWNDEERROR
    }
}
