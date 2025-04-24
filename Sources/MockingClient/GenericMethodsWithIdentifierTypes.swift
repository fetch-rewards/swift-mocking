//
//  GenericMethodsWithIdentifierTypes.swift
//
//  Copyright © 2025 Fetch.
//

// swiftformat:disable typeSugar

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of generic methods with
/// identifier types.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods with identifier types. For temporary
///   testing of Mocked's expansion, use the `Playground` protocol in
///   `main.swift`.
@Mocked
public protocol GenericMethodsWithIdentifierTypes {
    func genericMethodWithArrayIdentifierTypeAndUnconstrainedGenericParameter<Value>(
        parameter: Array<Value>
    ) -> Array<Value>

    func genericMethodWithArrayIdentifierTypeAndConstrainedGenericParameter<
        Value: Equatable
    >(
        parameter: Array<Value>
    ) -> Array<Value> where Value: Sendable, Value: Comparable & Hashable

    func genericMethodWithDictionaryIdentifierTypeAndUnconstrainedGenericParameters<
        Key,
        Value
    >(
        parameter: Dictionary<Key, Value>
    ) -> Dictionary<Key, Value>

    func genericMethodWithDictionaryIdentifierTypeAndConstrainedGenericParameters<
        Key: Hashable,
        Value: Equatable
    >(
        parameter: Dictionary<Key, Value>
    ) -> Dictionary<Key, Value> where Key: Sendable, Value: Comparable & Hashable

    func genericMethodWithOptionalIdentifierTypeAndUnconstrainedGenericParameter<
        Value
    >(
        parameter: Optional<Value>
    ) -> Optional<Value>

    func genericMethodWithOptionalIdentifierTypeAndConstrainedGenericParameter<
        Value: Equatable
    >(
        parameter: Optional<Value>
    ) -> Optional<Value> where Value: Sendable, Value: Comparable & Hashable

    func genericMethodWithSetIdentifierTypeAndUnconstrainedGenericParameter<
        Value
    >(
        parameter: Set<Value>
    ) -> Set<Value>

    func genericMethodWithSetIdentifierTypeAndConstrainedGenericParameter<
        Value: Equatable
    >(
        parameter: Set<Value>
    ) -> Set<Value> where Value: Sendable, Value: Comparable & Hashable
}
