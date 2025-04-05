//
//  AttributedTypes.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of attributed types.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of attributed types. For temporary testing of Mocked's
///   expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol AttributedTypes {
    func voidMethod(
        inoutParameter: inout Int,
        consumingParameter: consuming String
    )

    func voidAsyncMethod(
        inoutParameter: inout Int,
        consumingParameter: consuming String
    ) async

    func voidThrowingMethod(
        inoutParameter: inout Int,
        consumingParameter: consuming String
    ) throws

    func voidAsyncThrowingMethod(
        inoutParameter: inout Int,
        consumingParameter: consuming String
    ) async throws

    func returningMethod(
        inoutParameter: inout Int,
        consumingParameter: consuming String
    ) -> Bool

    func returningAsyncMethod(
        inoutParameter: inout Int,
        consumingParameter: consuming String
    ) async -> Bool

    func returningThrowingMethod(
        inoutParameter: inout Int,
        consumingParameter: consuming String
    ) throws -> Bool

    func returningAsyncThrowingMethod(
        inoutParameter: inout Int,
        consumingParameter: consuming String
    ) async throws -> Bool
}
