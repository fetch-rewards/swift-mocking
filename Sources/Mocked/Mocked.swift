//
//  Mocked.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
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
@attached(peer, names: suffixed(Mock))
public macro Mocked() = #externalMacro(
    module: "MockedMacros",
    type: "MockedMacro"
)
