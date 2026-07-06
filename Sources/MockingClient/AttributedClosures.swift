//
//  AttributedClosures.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of closure parameters whose types
/// carry attributes such as `@Sendable` and global actor attributes like
/// `@MainActor`.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of attributed closure parameters. For temporary testing
///   of Mocked's expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol AttributedClosures: Sendable {

    // MARK: Sendable

    func sendableVoidMethod(
        work: @escaping @Sendable () -> Void
    )
    func sendableVoidAsyncMethod(
        work: @escaping @Sendable () -> Void
    ) async
    func sendableVoidThrowingMethod(
        work: @escaping @Sendable () -> Void
    ) throws
    func sendableVoidAsyncThrowingMethod(
        work: @escaping @Sendable () -> Void
    ) async throws

    func sendableReturningMethod(
        work: @escaping @Sendable () -> Void
    ) -> Bool
    func sendableReturningAsyncMethod(
        work: @escaping @Sendable () -> Void
    ) async -> Bool
    func sendableReturningThrowingMethod(
        work: @escaping @Sendable () -> Void
    ) throws -> Bool
    func sendableReturningAsyncThrowingMethod(
        work: @escaping @Sendable () -> Void
    ) async throws -> Bool

    // MARK: MainActor Sendable

    func mainActorVoidMethod(
        work: @escaping @MainActor @Sendable () -> Void
    )
    func mainActorVoidAsyncMethod(
        work: @escaping @MainActor @Sendable () -> Void
    ) async
    func mainActorVoidThrowingMethod(
        work: @escaping @MainActor @Sendable () -> Void
    ) throws
    func mainActorVoidAsyncThrowingMethod(
        work: @escaping @MainActor @Sendable () -> Void
    ) async throws

    func mainActorReturningMethod(
        work: @escaping @MainActor @Sendable () -> Void
    ) -> Bool
    func mainActorReturningAsyncMethod(
        work: @escaping @MainActor @Sendable () -> Void
    ) async -> Bool
    func mainActorReturningThrowingMethod(
        work: @escaping @MainActor @Sendable () -> Void
    ) throws -> Bool
    func mainActorReturningAsyncThrowingMethod(
        work: @escaping @MainActor @Sendable () -> Void
    ) async throws -> Bool
}
