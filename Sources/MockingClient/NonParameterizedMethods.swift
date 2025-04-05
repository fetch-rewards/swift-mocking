//
//  NonParameterizedMethods.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of non-parameterized methods.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of non-parameterized methods. For temporary testing of
///   Mocked's expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol NonParameterizedMethods {
    func voidMethod()
    func voidAsyncMethod() async
    func voidThrowingMethod() throws
    func voidAsyncThrowingMethod() async throws

    func returningMethod() -> Bool
    func returningAsyncMethod() async -> Bool
    func returningThrowingMethod() throws -> Bool
    func returningAsyncThrowingMethod() async throws -> Bool
}
