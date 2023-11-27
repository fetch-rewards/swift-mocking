//
//  MockReturningAsyncThrowingFunctionWithParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's returning, async,
/// throwing function that has parameters.
public final class MockReturningAsyncThrowingFunctionWithParameters<Arguments, ReturnValue> {

    // MARK: Properties

    /// The function's implementation.
    public var implementation: MockAsyncThrowingImplementation<ReturnValue> = .unimplemented

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The latest arguments with which the function has been invoked.
    public var latestInvocation: Arguments? {
        self.invocations.last
    }

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [Result<ReturnValue, Error>] = []

    /// The latest value returned by the function.
    public var latestReturnValue: Result<ReturnValue, Error>? {
        self.returnValues.last
    }

    /// The description of the mock's backing variable.
    private let description: MockImplementationDescription

    // MARK: Initializers

    /// Creates a returning, async, throwing function with parameters.
    private init(description: MockImplementationDescription) {
        self.description = description
    }

    // MARK: Factories

    /// Creates a new function and an async throwing closure to invoke the
    /// function, returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new function and an async throwing
    ///   closure to invoke the function.
    public static func makeFunction(
        description: MockImplementationDescription
    ) -> (
        function: MockReturningAsyncThrowingFunctionWithParameters,
        invoke: (Arguments) async throws -> ReturnValue
    ) {
        let function = Self(description: description)

        return (
            function: function,
            invoke: { try await function.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value or throws an error.
    ///
    /// - Parameter arguments: The arguments with which the function is being
    ///   invoked.
    /// - Throws: An error, if ``returnValue`` is `.failure`.
    /// - Returns: The function's return value.
    private func invoke(
        _ arguments: Arguments
    ) async throws -> ReturnValue {
        self.callCount += 1
        self.invocations.append(arguments)

        let returnValue = await Result {
            try await self.implementation(description: self.description)
        }

        self.returnValues.append(returnValue)

        return try returnValue.get()
    }
}
