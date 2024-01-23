import ProjectDescription
import ProjectDescriptionHelpers
import DependencyHelper

let project = Project.makeModule(
    name: "Presentation",
    resources: ["Resources/**"],
    platform: .iOS,
    product: .staticFramework,
    dependencies: [
        .Projects.domain,
        .Module.designSystem
    ]
)
