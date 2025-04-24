//
//  GenericMethodsWithMetatypes.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of generic methods with
/// metatypes.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods with metatypes. For temporary testing
///   of Mocked's expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol GenericMethodsWithMetatypes {
    func genericMethodWithGenericTypeMetatypeAndUnconstrainedGenericParameter<Value>(
        parameter: Value.Type
    ) -> Value.Type

    func genericMethodWithGenericTypeMetatypeAndConstrainedGenericParameter<
        Value: Equatable
    >(
        parameter: Value.Type
    ) -> Value.Type where Value: Sendable, Value: Comparable & Hashable

    func genericMethodWithOpaqueTypeMetatypeWithOneConstraint(
        parameter: (some Equatable).Type
    )

    func genericMethodWithOpaqueTypeMetatypeWithMultipleConstraints(
        parameter: (some Equatable & Sendable & Comparable).Type
    )
}
