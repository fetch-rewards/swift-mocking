//
//  GenericMethodsWithTupleTypes.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of generic methods with tuple
/// types.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods with tuple types. For temporary
///   testing of Mocked's expansion, use the `Playground` protocol in
///   `main.swift`.
@Mocked
public protocol GenericMethodsWithTupleTypes {
    func genericMethodWithTupleTypeAndUnconstrainedGenericParameters<Value1, Value2>(
        parameter: (Value1, Value2)
    ) -> (Value1, Value2)

    func genericMethodWithTupleTypeAndConstrainedGenericParameters<
        Value1: Equatable,
        Value2: Hashable
    >(
        parameter: (Value1, Value2)
    ) -> (Value1, Value2) where Value1: Sendable, Value2: Comparable
}
