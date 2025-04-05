//
//  GenericMethodsWithAttributedTypes.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of generic methods with
/// attributed types.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods with attributed types. For temporary
///   testing of Mocked's expansion, use the `Playground` protocol in
///   `main.swift`.
@Mocked
public protocol GenericMethodsWithAttributedTypes {
    func genericMethodWithAttributedTypesAndUnconstrainedGenericParameter<Value>(
        inoutParameter: inout Value,
        consumingParameter: consuming Value
    )

    func genericMethodWithAttributedTypesAndConstrainedGenericParameter<
        Value: Equatable
    >(
        inoutParameter: inout Value,
        consumingParameter: consuming Value
    ) where Value: Sendable, Value: Comparable & Hashable
}
