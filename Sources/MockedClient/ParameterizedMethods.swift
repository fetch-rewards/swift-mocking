//
//  ParameterizedMethods.swift
//  Mocked
//
//  Created by Gray Campbell on 3/25/25.
//

import Foundation
public import Mocked

/// A protocol for verifying Mocked's handling of parameterized methods.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of parameterized methods. For temporary testing of
///   Mocked's expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol ParameterizedMethods {
    func voidMethod(string: String, integer: Int)
    func voidAsyncMethod(string: String, integer: Int) async
    func voidThrowingMethod(string: String, integer: Int) throws
    func voidAsyncThrowingMethod(string: String, integer: Int) async throws

    func returningMethod(string: String, integer: Int) -> Bool
    func returningAsyncMethod(string: String, integer: Int) async -> Bool
    func returningThrowingMethod(string: String, integer: Int) throws -> Bool
    func returningAsyncThrowingMethod(string: String, integer: Int) async throws -> Bool
}
