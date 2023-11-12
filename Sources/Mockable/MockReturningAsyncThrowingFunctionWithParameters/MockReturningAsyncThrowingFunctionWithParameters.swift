//
//  MockReturningAsyncThrowingFunctionWithParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import XCTestDynamicOverlay

/// The invocation records and implementation for a mock's returning, async,
/// throwing function that has parameters.
public struct MockReturningAsyncThrowingFunctionWithParameters<
    Arguments, ReturnValue
> {

    // MARK: Properties

    /// The function's return value.
    public var returnValue: Result<ReturnValue, Error>?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The latest arguments with which the function has been invoked.
    public private(set) var latestInvocation: Arguments?

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [Result<ReturnValue, Error>] = []

    /// The latest value returned by the function.
    public private(set) var latestReturnValue: Result<ReturnValue, Error>?

    // MARK: Initializers

    /// Creates a returning, async, throwing function with parameters.
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
        invoke: (Arguments) async throws -> ReturnValue
    ) {
        var function = Self()

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
    private mutating func invoke(
        _ arguments: Arguments
    ) async throws -> ReturnValue {
        guard let returnValue = self.returnValue else {
            return unimplemented("\(Self.self).returnValue")
        }

        self.callCount += 1
        self.invocations.append(arguments)
        self.latestInvocation = arguments
        self.returnValues.append(returnValue)
        self.latestReturnValue = returnValue

        return try returnValue.get()
    }
}
