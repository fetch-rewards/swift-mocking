//
//  GenericMethods.swift
//  MockedClient
//
//  Created by Gray Campbell on 1/5/25.
//

import Foundation
public import Mocked

/// A protocol for verifying Mocked's handling of generic methods.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods. For temporary testing of Mocked's
///   expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol GenericMethods {
    func genericMethodWithArrayType<Element>(
        array: [Element]
    ) -> [Element]

    func genericMethodWithArrayIdentifierType<Element>(
        array: Array<Element>
    ) -> Array<Element>

    func genericMethodWithArrayMemberType<Element>(
        array: Swift.Array<Element>
    ) -> Swift.Array<Element>

    func genericMethodWithAttributedType<Value>(
        value: inout Value
    ) -> any Equatable

    func genericMethodWithDictionaryType<Key, Value>(
        dictionary: [Key: Value]
    ) -> [Key: Value]

    func genericMethodWithDictionaryIdentifierType<Key, Value>(
        dictionary: Dictionary<Key, Value>
    ) -> Dictionary<Key, Value>

    func genericMethodWithDictionaryMemberType<Key, Value>(
        dictionary: Dictionary<Key, Value>
    ) -> Dictionary<Key, Value>

    func genericMethodWithOptionalIdentifierType<Value>(
        value: Optional<Value>
    ) -> Optional<Value>

    func genericMethodWithIdentifierType<Value>(value: Value) -> Value

    func genericMethodWithMetatypeType<Value>(valueType: Value.Type) -> Value.Type

    func genericMethodWithOpaqueType(value: some Comparable & Equatable)
}
