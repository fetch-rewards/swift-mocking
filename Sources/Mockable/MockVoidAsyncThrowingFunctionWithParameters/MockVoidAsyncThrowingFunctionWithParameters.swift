//
//  MockVoidAsyncThrowingFunctionWithParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's void, async, throwing
/// function that has parameters.
public struct MockVoidAsyncThrowingFunctionWithParameters<Arguments> {

    // MARK: Properties

    /// The error thrown by the function.
    public var error: Error?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The latest arguments with which the function has been invoked.
    public private(set) var latestInvocation: Arguments?

    /// All the errors that have been thrown by the function.
    public private(set) var errors: [Error] = []

    // MARK: Initializers

    /// Creates a void, async, throwing function with parameters.
    private init() {}

    // MARK: Factories

    /// Creates a new function and an async throwing closure to invoke the
    /// function, returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new function and an async throwing
    /// closure to invoke the function.
    public static func makeFunction(
    ) -> (
        function: Self,
        invoke: (Arguments) async throws -> Void
    ) {
        var function = Self()

        return (
            function,
            { try await function.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and throws an error if ``error``
    /// is not `nil`.
    ///
    /// - Parameter arguments: The arguments with which the function is being
    ///   invoked.
    /// - Throws: ``error``, if it is not `nil`.
    private mutating func invoke(_ arguments: Arguments) async throws {
        self.callCount += 1
        self.invocations.append(arguments)
        self.latestInvocation = arguments

        guard let error = self.error else { return }

        self.errors.append(error)

        throw error
    }
}
