import ProjectDescription
import ProjectDescriptionHelpers
import DependencyHelper

let project = Project.makeModule(
    name: "Core",
    platform: .iOS,
    product: .staticFramework,
    dependencies: [
        .Module.thirdPartyLib,
        .Module.appLogger
    ]
)
