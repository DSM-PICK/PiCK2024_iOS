import ProjectDescription
import DependencyPlugin
import EnvironmentPlugin

extension Project {
    public static func makeModule(
        name: String,
        organizationName: String = env.organizationName,
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        platform: Platform = env.platform,
        product: Product,
        packages: [Package] = [],
        dependencies: [TargetDependency]
    ) -> Project {

        let addTarget: Target = .init(
            name: name,
            platform: platform,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTarget: env.deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )

        return .init(
            name: name,
            organizationName: organizationName,
            packages: packages,
            targets: [addTarget],
            fileHeaderTemplate: nil,
            resourceSynthesizers: .default
        )
    }
}
