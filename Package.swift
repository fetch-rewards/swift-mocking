// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "Mocked",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13),
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
            url: "https://github.com/apple/swift-syntax.git",
            exact: "509.0.2"
        ),
        .package(
            url: "git@github.com:fetch-rewards/SwiftSyntaxSugar.git",
            branch: "refactor/SyntaxProtocol-with"
        ),
        .package(
            url: "https://github.com/pointfreeco/xctest-dynamic-overlay",
            exact: "1.0.2"
        ),
    ],
    targets: [
        .macro(
            name: "MockedMacros",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxSugar", package: "SwiftSyntaxSugar"),
            ]
        ),
        .target(
            name: "Mocked",
            dependencies: [
                "MockedMacros",
                .product(
                    name: "XCTestDynamicOverlay",
                    package: "xctest-dynamic-overlay"
                ),
            ]
        ),
        .executableTarget(
            name: "MockedClient",
            dependencies: ["Mocked"]
        ),
        .testTarget(
            name: "MockedMacrosTests",
            dependencies: [
                "MockedMacros",
                .product(
                    name: "SwiftSyntaxMacrosTestSupport",
                    package: "swift-syntax"
                ),
            ]
        ),
        .testTarget(
            name: "MockedTests",
            dependencies: [
                "Mocked",
            ]
        ),
    ]
)
