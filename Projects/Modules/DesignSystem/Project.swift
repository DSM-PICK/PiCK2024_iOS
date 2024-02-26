import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "DesignSystem",
    resources: ["Resources/**"],
    platform: .iOS,
    product: .framework,
    dependencies: [
        .Projects.core
    ]
)
