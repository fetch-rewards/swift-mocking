//
//  Mocked.swift
//
//  Copyright © 2025 Fetch.
//

/// A macro that produces a mock when attached to a protocol.
///
/// For example:
/// ```swift
/// @Mocked
/// public protocol Dependency { ... }
/// ```
/// produces a mock that conforms to `Dependency`:
/// ```swift
/// public final class DependencyMock: Dependency { ... }
/// ```
///
/// - Parameters:
///   - compilationCondition: The compilation condition to apply to the
///     `#if` compiler directive used to wrap the generated mock.
///   - sendableConformance: The `Sendable` conformance to apply to
///     the generated mock.
@attached(peer, names: suffixed(Mock))
public macro Mocked(
    compilationCondition: MockCompilationCondition = .swiftMockingEnabled,
    sendableConformance: MockSendableConformance = .checked
) = #externalMacro(
    module: "MockingMacros",
    type: "MockedMacro"
)
