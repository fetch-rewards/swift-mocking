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
            url: "https://github.com/fetch-rewards/swift-synchronization.git",
            exact: "0.1.0"
        ),
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            exact: "600.0.0" // Must match SwiftSyntaxSugar's swift-syntax version
        ),
        .package(
            url: "https://github.com/fetch-rewards/SwiftSyntaxSugar.git",
            exact: "0.1.0" // Must match swift-synchronization's SwiftSyntaxSugar version
        ),
    ],
    targets: [
        .target(
            name: "Mocking",
            dependencies: [
                "MockingMacros",
                .product(
                    name: "Synchronization",
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
