//
//  AutoClosures.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of autoclosures.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of autoclosures. For temporary testing of Mocked's
///   expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol AutoClosures {
    func methodWithVoidAutoClosure(autoClosure: @escaping @autoclosure () -> Void)
    func methodWithNonVoidAutoClosure(autoClosure: @escaping @autoclosure () -> Int)
    func methodWithVoidAsyncAutoClosure(autoClosure: @escaping @autoclosure () async -> Void) async
    func methodWithNonVoidAsyncAutoClosure(
        autoClosure: @escaping @autoclosure () async -> Int
    ) async
    func methodWithVoidThrowingAutoClosure(
        autoClosure: @escaping @autoclosure () throws -> Void
    ) throws
    func methodWithNonVoidThrowingAutoClosure(
        autoClosure: @escaping @autoclosure () throws -> Int
    ) throws
    func methodWithVoidAsyncThrowingAutoClosure(
        autoClosure: @escaping @autoclosure () async throws -> Void
    ) async throws
    func methodWithNonVoidAsyncThrowingAutoClosure(
        autoClosure: @escaping @autoclosure () async throws -> Int
    ) async throws
}
