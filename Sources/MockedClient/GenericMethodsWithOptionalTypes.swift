//
//  GenericMethodsWithOptionalTypes.swift
//  MockedClient
//
//  Created by Gray Campbell on 1/12/25.
//

import Foundation
public import Mocked

/// A protocol for verifying Mocked's handling of generic methods with
/// `Optional` types.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods with `Optional` types. For temporary
///   testing of Mocked's expansion, use the `Playground` protocol in
///   `main.swift`.
@Mocked
public protocol GenericMethodsWithOptionalTypes {
    func genericMethodWithOptionalTypeAndUnconstrainedGenericParameter<Value>(
        parameter: Value?
    ) -> Value?

    func genericMethodWithOptionalTypeAndConstrainedGenericParameter<Value: Equatable>(
        parameter: Value?
    ) -> Value? where Value: Sendable, Value: Comparable & Hashable
}
