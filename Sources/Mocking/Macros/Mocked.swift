//
//  Mocked.swift
//
//  Created by Gray Campbell.
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
/// - Parameter compilationCondition: The compilation condition to apply to the
///   `#if` compiler directive used to wrap the generated mock.
@attached(peer, names: suffixed(Mock))
public macro Mocked(
    compilationCondition: MockCompilationCondition = .swiftMockingEnabled
) = #externalMacro(
    module: "MockingMacros",
    type: "MockedMacro"
)
