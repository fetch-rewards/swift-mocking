//
//  GenericMethodsWithFunctionTypes.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of generic methods with function
/// types.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods with function types. For temporary
///   testing of Mocked's expansion, use the `Playground` protocol in
///   `main.swift`.
@Mocked
public protocol GenericMethodsWithFunctionTypes {
    func genericMethodWithFunctionTypeAndUnconstrainedGenericParameters<Value>(
        parameter: @escaping (String) -> Value
    ) -> (String) -> Value

    func genericMethodWithFunctionTypeAndConstrainedGenericParameters<Value: Sendable>(
        parameter: @escaping (String) -> Value
    ) -> (String) -> Value where Value: Equatable
}
