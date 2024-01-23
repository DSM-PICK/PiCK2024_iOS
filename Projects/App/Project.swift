import ProjectDescription
import ProjectDescriptionHelpers
import DependencyHelper

let project = Project(
    name: "PICK2024-iOS",
    organizationName: "com.choyj",
    targets: [
        Target(
            name: "PICK2024-iOS",
            platform: .iOS,
            product: .app,
            bundleId: "com.choyj.iOS.app",
            deploymentTarget: .iOS(
                targetVersion: "15.0",
                devices: [.iphone, .ipad]
            ),
            infoPlist: .file(path: "Support/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .Projects.flow
            ]
        )
    ]
)
