import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    static let Moya = TargetDependency.external(name: "Moya")
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let Then = TargetDependency.external(name: "Then")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let RxMoya = TargetDependency.external(name: "RxMoya")
    static let KeychainSwift = TargetDependency.external(name: "KeychainSwift")
    static let RxFlow = TargetDependency.external(name: "RxFlow")
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
}
