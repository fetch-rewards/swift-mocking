// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "Mocked",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .macCatalyst(.v16),
    ],
    products: [
        .library(
            name: "Mocked",
            targets: ["Mocked"]
        ),
        .executable(
            name: "MockedClient",
            targets: ["MockedClient"]
        ),
    ],
    dependencies: [
        .package(
            url: "git@github.com:fetch-rewards/swift-locking.git",
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
            name: "Mocked",
            dependencies: [
                "MockedMacros",
                .product(
                    name: "Locked",
                    package: "swift-locking"
                ),
            ],
            swiftSettings: .default
        ),
        .testTarget(
            name: "MockedTests",
            dependencies: ["Mocked"],
            swiftSettings: .default
        ),
        .executableTarget(
            name: "MockedClient",
            dependencies: ["Mocked"],
            swiftSettings: .default
        ),
        .macro(
            name: "MockedMacros",
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
            name: "MockedMacrosTests",
            dependencies: [
                "MockedMacros",
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
