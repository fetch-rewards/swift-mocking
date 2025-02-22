//
//  MockVoidMethodImplementation.swift
//  Mocked
//
//  Created by Gray Campbell on 2/17/25.
//

import Foundation

/// An implementation for a mock void method.
public protocol MockVoidMethodImplementation<
    Arguments,
    Error,
    Closure
>: MockMethodImplementation {}

// MARK: - Non-Sendable

extension MockVoidMethodImplementation
    where Error: Swift.Error,
          Closure == () throws -> Void
{
    /// Throws the provided error when invoked.
    ///
    /// - Parameter error: The error to throw.
    static func `throws`(_ error: Error) -> Self {
        .uncheckedInvokes { throw error }
    }
}

extension MockVoidMethodImplementation
    where Error: Swift.Error,
          Closure == () async throws -> Void
{
    /// Throws the provided error when invoked.
    ///
    /// - Parameter error: The error to throw.
    static func `throws`(_ error: Error) -> Self {
        .uncheckedInvokes { throw error }
    }
}

// MARK: - Sendable

extension MockVoidMethodImplementation
    where Error: Swift.Error,
          Closure == @Sendable () throws -> Void
{
    /// Throws the provided error when invoked.
    ///
    /// - Parameter error: The error to throw.
    static func `throws`(_ error: Error) -> Self {
        .invokes { throw error }
    }
}

extension MockVoidMethodImplementation
    where Error: Swift.Error,
          Closure == @Sendable () async throws -> Void
{
    /// Throws the provided error when invoked.
    ///
    /// - Parameter error: The error to throw.
    static func `throws`(_ error: Error) -> Self {
        .invokes { throw error }
    }
}
