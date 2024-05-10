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
            from: "1.1.0"
        ),
    ],
    targets: [
        .macro(
            name: "MockedMacros",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxSugar", package: "SwiftSyntaxSugar"),
            ],
            swiftSettings: .default
        ),
        .target(
            name: "Mocked",
            dependencies: [
                "MockedMacros",
                .product(
                    name: "XCTestDynamicOverlay",
                    package: "xctest-dynamic-overlay"
                ),
            ],
            swiftSettings: .default
        ),
        .executableTarget(
            name: "MockedClient",
            dependencies: ["Mocked"],
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
        .testTarget(
            name: "MockedTests",
            dependencies: [
                "Mocked",
            ],
            swiftSettings: .default
        ),
    ]
)

// MARK: - Swift Settings

/// For a list of all upcoming features, visit the [Swift Evolution Dashboard]
/// (https://www.swift.org/swift-evolution/#?upcoming=true)
extension SwiftSetting {

    // MARK: Upcoming Features

    /// A Swift feature that adds the option to create regular expressions from
    /// regular expression literals.
    ///
    /// [Swift Evolution proposal]
    /// (https://github.com/apple/swift-evolution/blob/main/proposals/0354-regex-literals.md)
    static let bareSlashRegexLiterals: SwiftSetting = .enableUpcomingFeature("BareSlashRegexLiterals")

    /// A Swift feature that changes the evaluation of `#file` from a string
    /// literal containing the current source file's full path to a
    /// human-readable string containing the filename and module name, while
    /// preserving the former behavior in a new `#filePath` expression.
    ///
    /// [Swift Evolution proposal]
    /// (https://github.com/apple/swift-evolution/blob/main/proposals/0274-magic-file.md)
    static let conciseMagicFile: SwiftSetting = .enableUpcomingFeature("ConciseMagicFile")

    /// A Swift feature that disables global actor isolation inference for types
    /// that contain property wrappers that are isolated to a global actor.
    ///
    /// [Swift Evolution proposal]
    /// (https://github.com/apple/swift-evolution/blob/main/proposals/0401-remove-property-wrapper-isolation.md)
    static let disableOutwardActorInference: SwiftSetting = .enableUpcomingFeature("DisableOutwardActorInference")

    /// A Swift feature that enforces the use of the `any` keyword for
    /// existential types.
    ///
    /// [Swift Evolution proposal]
    /// (https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md)
    static let existentialAny: SwiftSetting = .enableUpcomingFeature("ExistentialAny")

    /// A Swift feature that replaces backward-scan matching for multiple
    /// trailing closures with forward-scan matching wherever possible.
    ///
    /// [Swift Evolution proposal]
    /// (https://github.com/apple/swift-evolution/blob/main/proposals/0286-forward-scan-trailing-closures.md)
    static let forwardTrailingClosures: SwiftSetting = .enableUpcomingFeature("ForwardTrailingClosures")

    /// A Swift feature that improves the default API interface of imported
    /// Objective-C code that uses forward declarations.
    ///
    /// [Swift Evolution proposal]
    /// (https://github.com/apple/swift-evolution/blob/main/proposals/0384-importing-forward-declared-objc-interfaces-and-protocols.md)
    static let importObjcForwardDeclarations: SwiftSetting = .enableUpcomingFeature("ImportObjcForwardDeclarations")

    // MARK: Experimental Features

    /// A Swift feature that enables strict concurrency checking.
    ///
    /// Although this is marked as an "experimental" feature, it is still safe
    /// to enable. Strict concurrency checking is still evolving and is [not yet
    /// in its final Swift 6 form](https://github.com/apple/swift/pull/66991)
    /// like "upcoming" features are.
    ///
    /// [Swift Evolution proposal]
    /// (https://github.com/apple/swift-evolution/blob/main/proposals/0337-support-incremental-migration-to-concurrency-checking.md)
    static let strictConcurrency: SwiftSetting = .enableExperimentalFeature("StrictConcurrency")
}

extension Array where Element == SwiftSetting {

    /// Default Swift settings to enable for targets.
    static let `default`: [SwiftSetting] = [
        .bareSlashRegexLiterals,
        .conciseMagicFile,
        .disableOutwardActorInference,
        .existentialAny,
        .forwardTrailingClosures,
        .importObjcForwardDeclarations,
        .strictConcurrency,
    ]
}
