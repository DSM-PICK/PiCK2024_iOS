import ProjectDescription
import ProjectDescriptionHelpers
import DependencyHelper

let project = Project(
    name: "PICK-iOS",
    organizationName: "com.pick",
    targets: [
        Target(
            name: "PICK-iOS",
            platform: .iOS,
            product: .app,
            bundleId: "com.pick.app",
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
