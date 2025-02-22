//
//  MockReturningMethodImplementation.swift
//  Mocked
//
//  Created by Gray Campbell on 2/15/25.
//

import Foundation

/// An implementation for a mock returning method.
public protocol MockReturningMethodImplementation<
    Arguments,
    Error,
    ReturnValue,
    Closure
>: MockMethodImplementation {

    /// The implementation's return value type.
    associatedtype ReturnValue
}

// MARK: - Non-Sendable

extension MockReturningMethodImplementation
    where Closure == () -> ReturnValue {

    /// Returns the provided value when invoked.
    ///
    /// - Parameter value: The value to return.
    static func uncheckedReturns(_ value: ReturnValue) -> Self {
        .uncheckedInvokes { value }
    }
}

extension MockReturningMethodImplementation
    where Error: Swift.Error,
          Closure == () throws -> ReturnValue
{

    /// Throws the provided error when invoked.
    ///
    /// - Parameter error: The error to throw.
    static func `throws`(_ error: Error) -> Self {
        .uncheckedInvokes { throw error }
    }

    /// Returns the provided value when invoked.
    ///
    /// - Parameter value: The value to return.
    static func uncheckedReturns(_ value: ReturnValue) -> Self {
        .uncheckedInvokes { value }
    }
}

extension MockReturningMethodImplementation
    where Error: Swift.Error,
          Closure == () async throws -> ReturnValue
{

    /// Throws the provided error when invoked.
    ///
    /// - Parameter error: The error to throw.
    static func `throws`(_ error: Error) -> Self {
        .uncheckedInvokes { throw error }
    }

    /// Returns the provided value when invoked.
    ///
    /// - Parameter value: The value to return.
    static func uncheckedReturns(_ value: ReturnValue) -> Self {
        .uncheckedInvokes { value }
    }
}

// MARK: - Sendable

extension MockReturningMethodImplementation
    where ReturnValue: Sendable,
          Closure == @Sendable () -> ReturnValue
{

    /// Returns the provided value when invoked.
    ///
    /// - Parameter value: The value to return.
    public static func returns(_ value: ReturnValue) -> Self {
        .invokes { value }
    }
}

extension MockReturningMethodImplementation
    where Error: Swift.Error,
          ReturnValue: Sendable,
          Closure == @Sendable () throws -> ReturnValue
{

    /// Throws the provided error when invoked.
    ///
    /// - Parameter error: The error to throw.
    static func `throws`(_ error: Error) -> Self {
        .invokes { throw error }
    }

    /// Returns the provided value when invoked.
    ///
    /// - Parameter value: The value to return.
    public static func returns(_ value: ReturnValue) -> Self {
        .invokes { value }
    }
}

extension MockReturningMethodImplementation
    where Error: Swift.Error,
          ReturnValue: Sendable,
          Closure == @Sendable () async throws -> ReturnValue
{

    /// Throws the provided error when invoked.
    ///
    /// - Parameter error: The error to throw.
    static func `throws`(_ error: Error) -> Self {
        .invokes { throw error }
    }

    /// Returns the provided value when invoked.
    ///
    /// - Parameter value: The value to return.
    public static func returns(_ value: ReturnValue) -> Self {
        .invokes { value }
    }
}
