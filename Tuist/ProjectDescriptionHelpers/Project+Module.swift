import ProjectDescription

extension Project {
    public static func makeModule(
        name: String,
        organizationName: String = "com.pick",
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        platform: Platform,
        product: Product,
        packages: [Package] = [],
        dependencies: [TargetDependency]
    ) -> Project {

        let addTarget: Target = .init(
            name: name,
            platform: platform,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTarget: .iOS(
                targetVersion: "15.0",
                devices: [.iphone, .ipad]
            ),
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
