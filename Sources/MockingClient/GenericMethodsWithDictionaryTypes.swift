//
//  GenericMethodsWithDictionaryTypes.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of generic methods with
/// `Dictionary` types.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods with `Dictionary` types. For
///   temporary testing of Mocked's expansion, use the `Playground` protocol in
///   `main.swift`.
@Mocked
public protocol GenericMethodsWithDictionaryTypes {
    func genericMethodWithDictionaryTypeAndUnconstrainedGenericParameters<Key, Value>(
        parameter: [Key: Value]
    ) -> [Key: Value]

    func genericMethodWithDictionaryTypeAndConstrainedGenericParameters<
        Key: Hashable,
        Value: Equatable
    >(
        parameter: [Key: Value]
    ) -> [Key: Value] where Key: Sendable, Value: Comparable & Hashable
}
