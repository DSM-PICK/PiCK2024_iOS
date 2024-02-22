import ProjectDescription
import ProjectDescriptionHelpers
import EnvironmentPlugin
import DependencyPlugin

let targets: [Target] = [
    .init(
        name: env.targetName,
        platform: env.platform,
        product: .app,
        bundleId: "\(env.organizationName)",
        deploymentTarget: env.deploymentTarget,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        scripts: [],
        dependencies: [
            .Projects.flow
        ],
        settings: .settings(base: env.baseSetting)
    )
]

let project = Project(
    name: env.targetName,
    organizationName: env.organizationName,
    targets: targets
)
