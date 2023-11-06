// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces a mock when attached to a protocol.
///
/// For example:
/// ```swift
/// @Mockable
/// public protocol Dependency { ... }
/// ```
/// produces a mock that conforms to `Dependency`:
/// ```swift
/// public final class DependencyMock: Dependency { ... }
/// ```
@attached(peer, names: suffixed(Mock))
public macro Mockable() =
    #externalMacro(
        module: "MockableMacros",
        type: "MockableMacro"
    )
