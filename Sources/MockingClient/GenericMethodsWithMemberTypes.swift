//
//  GenericMethodsWithMemberTypes.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of generic methods with member
/// types.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods with member types. For temporary
///   testing of Mocked's expansion, use the `Playground` protocol in
///   `main.swift`.
@Mocked
public protocol GenericMethodsWithMemberTypes {
    func genericMethodWithArrayMemberTypeAndUnconstrainedGenericParameter<Value>(
        parameter: Swift.Array<Value>
    ) -> Swift.Array<Value>

    func genericMethodWithArrayMemberTypeAndConstrainedGenericParameter<
        Value: Equatable
    >(
        parameter: Swift.Array<Value>
    ) -> Swift.Array<Value> where Value: Sendable, Value: Comparable & Hashable

    func genericMethodWithDictionaryMemberTypeAndUnconstrainedGenericParameters<
        Key,
        Value
    >(
        parameter: Swift.Dictionary<Key, Value>
    ) -> Swift.Dictionary<Key, Value>

    func genericMethodWithDictionaryMemberTypeAndConstrainedGenericParameters<
        Key: Hashable,
        Value: Equatable
    >(
        parameter: Swift.Dictionary<Key, Value>
    ) -> Swift.Dictionary<Key, Value> where Key: Sendable, Value: Comparable & Hashable

    func genericMethodWithOptionalMemberTypeAndUnconstrainedGenericParameter<
        Value
    >(
        parameter: Swift.Optional<Value>
    ) -> Swift.Optional<Value>

    func genericMethodWithOptionalMemberTypeAndConstrainedGenericParameter<
        Value: Equatable
    >(
        parameter: Swift.Optional<Value>
    ) -> Swift.Optional<Value> where Value: Sendable, Value: Comparable & Hashable

    func genericMethodWithSetMemberTypeAndUnconstrainedGenericParameter<
        Value
    >(
        parameter: Swift.Set<Value>
    ) -> Swift.Set<Value>

    func genericMethodWithSetMemberTypeAndConstrainedGenericParameter<
        Value: Equatable
    >(
        parameter: Swift.Set<Value>
    ) -> Swift.Set<Value> where Value: Sendable, Value: Comparable & Hashable
}
