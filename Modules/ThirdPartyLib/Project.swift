import ProjectDescription
import ProjectDescriptionHelpers
import DependencyHelper

let project = Project.makeModule(
    name: "ThirdPartyLib",
    platform: .iOS,
    product: .framework,
    dependencies: [
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.RxFlow,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.KeychainSwift,
        .SPM.Kingfisher,
        .SPM.Moya,
        .SPM.RxGesture
    ]
)
