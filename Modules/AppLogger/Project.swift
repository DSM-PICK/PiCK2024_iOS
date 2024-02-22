import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "AppLogger",
    platform: .iOS,
    product: .framework,
    dependencies: [
        .Module.thirdPartyLib
    ]
)
