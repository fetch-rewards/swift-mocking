//
//  GenericMethodsWithArrayTypes.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of generic methods with `Array`
/// types.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods with `Array` types. For temporary
///   testing of Mocked's expansion, use the `Playground` protocol in
///   `main.swift`.
@Mocked
public protocol GenericMethodsWithArrayTypes {
    func genericMethodWithArrayTypeAndUnconstrainedGenericParameter<Value>(
        parameter: [Value]
    ) -> [Value]

    func genericMethodWithArrayTypeAndConstrainedGenericParameter<Value: Equatable>(
        parameter: [Value]
    ) -> [Value] where Value: Sendable, Value: Comparable & Hashable
}
