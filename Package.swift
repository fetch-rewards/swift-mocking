// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "Mockable",
    platforms: [
        .macOS(.v10_15), 
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13),
    ],
    products: [
        .library(
            name: "Mockable",
            targets: ["Mockable"]
        ),
        .executable(
            name: "MockableClient",
            targets: ["MockableClient"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-syntax.git", 
            from: "509.0.0"
        ),
        .package(
            url: "https://github.com/graycampbell/SwiftSyntaxSugar",
            branch: "feature/protocol-decl-syntax"
        ),
    ],
    targets: [
        .macro(
            name: "MockableMacros",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxSugar", package: "SwiftSyntaxSugar"),
            ]
        ),
        .target(
            name: "Mockable",
            dependencies: ["MockableMacros"]
        ),
        .executableTarget(
            name: "MockableClient",
            dependencies: ["Mockable"]
        ),
        .testTarget(
            name: "MockableMacrosTests",
            dependencies: [
                "MockableMacros",
                .product(
                    name: "SwiftSyntaxMacrosTestSupport",
                    package: "swift-syntax"
                ),
            ]
        ),
    ]
)
