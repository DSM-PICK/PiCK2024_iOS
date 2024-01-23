import ProjectDescription
import ProjectDescriptionHelpers
import DependencyHelper

let project = Project.makeModule(
    name: "AppNetwork",
    platform: .iOS,
    product: .framework,
    dependencies: [
        .Projects.core
    ]
)
