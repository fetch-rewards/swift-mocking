// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-mocking",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .macCatalyst(.v16),
    ],
    products: [
        .library(
            name: "Mocking",
            targets: ["Mocking"]
        ),
        .executable(
            name: "MockingClient",
            targets: ["MockingClient"]
        ),
    ],
    dependencies: [
        .package(
            url: "git@github.com:fetch-rewards/swift-synchronization.git",
            revision: "0fb7f20b63d3e2be4eb5197f7211e862611adae3"
        ),
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            exact: "600.0.0"
        ),
        .package(
            url: "git@github.com:fetch-rewards/SwiftSyntaxSugar.git",
            revision: "0284c7bd20959bf069b7de56788756697a502ff2"
        ),
    ],
    targets: [
        .target(
            name: "Mocking",
            dependencies: [
                "MockingMacros",
                .product(
                    name: "Locked",
                    package: "swift-synchronization"
                ),
            ],
            swiftSettings: .default
        ),
        .testTarget(
            name: "MockingTests",
            dependencies: ["Mocking"],
            swiftSettings: .default
        ),
        .executableTarget(
            name: "MockingClient",
            dependencies: ["Mocking"],
            swiftSettings: .default
        ),
        .macro(
            name: "MockingMacros",
            dependencies: [
                .product(
                    name: "SwiftCompilerPlugin",
                    package: "swift-syntax"
                ),
                .product(
                    name: "SwiftSyntaxMacros",
                    package: "swift-syntax"
                ),
                .product(
                    name: "SwiftSyntaxSugar",
                    package: "SwiftSyntaxSugar"
                ),
            ],
            swiftSettings: .default
        ),
        .testTarget(
            name: "MockingMacrosTests",
            dependencies: [
                "MockingMacros",
                .product(
                    name: "SwiftSyntaxMacrosTestSupport",
                    package: "swift-syntax"
                ),
            ],
            swiftSettings: .default
        ),
    ]
)

// MARK: - Swift Settings

extension SwiftSetting {
    static let existentialAny: SwiftSetting = .enableUpcomingFeature(
        "ExistentialAny"
    )

    static let internalImportsByDefault: SwiftSetting = .enableUpcomingFeature(
        "InternalImportsByDefault"
    )
}

extension [SwiftSetting] {

    /// Default Swift settings to enable for targets.
    static let `default`: [SwiftSetting] = [
        .existentialAny,
        .internalImportsByDefault,
    ]
}
