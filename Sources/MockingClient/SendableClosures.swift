//
//  SendableClosures.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of @Sendable closure parameters
/// on Sendable protocols.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of @Sendable closure parameters. For temporary testing
///   of Mocked's expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol SendableClosures: Sendable {
    func voidMethod(work: @escaping @Sendable () -> Void)
    func voidAsyncMethod(work: @escaping @Sendable () -> Void) async
    func voidThrowingMethod(work: @escaping @Sendable () -> Void) throws
    func voidAsyncThrowingMethod(work: @escaping @Sendable () -> Void) async throws

    func returningMethod(work: @escaping @Sendable () -> Void) -> Bool
    func returningAsyncMethod(work: @escaping @Sendable () -> Void) async -> Bool
    func returningThrowingMethod(work: @escaping @Sendable () -> Void) throws -> Bool
    func returningAsyncThrowingMethod(work: @escaping @Sendable () -> Void) async throws -> Bool
}
