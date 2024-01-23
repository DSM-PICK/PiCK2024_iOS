import ProjectDescription
import ProjectDescriptionHelpers
import DependencyHelper

let project = Project.makeModule(
    name: "DesignSystem",
    resources: ["Resources/**"],
    platform: .iOS,
    product: .framework,
    dependencies: [
        .Projects.core
    ]
)
