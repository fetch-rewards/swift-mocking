//
//  MockVoidAsyncThrowingFunctionWithParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's void, async,
/// throwing function with parameters.
public final class MockVoidAsyncThrowingFunctionWithParameters<Arguments> {

    // MARK: Properties

    /// The error thrown by the function.
    public var error: Error?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The latest arguments with which the function has been invoked.
    public var latestInvocation: Arguments? {
        self.invocations.last
    }

    /// All the errors that have been thrown by the function.
    public private(set) var errors: [Error] = []

    /// The latest error thrown by the function.
    public var latestError: Error? {
        self.errors.last
    }

    // MARK: Initializers

    /// Creates a void, async, throwing function with parameters.
    private init() {}

    // MARK: Factories

    /// Creates a function and an async throwing closure for invoking the
    /// function, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidAsyncThrowingFunctionWithParameters<(String, String)>.makeFunction()
    ///
    /// public var _logIn: MockVoidAsyncThrowingFunctionWithParameters<(String, String)> {
    ///     self.__logIn.function
    /// }
    ///
    /// public func logIn(username: String, password: String) async throws {
    ///     try await self.__logIn.invoke((username, password))
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a function and an async throwing closure
    ///   for invoking the function.
    public static func makeFunction(
    ) -> (
        function: MockVoidAsyncThrowingFunctionWithParameters,
        invoke: (Arguments) async throws -> Void
    ) {
        let function = MockVoidAsyncThrowingFunctionWithParameters()

        return (
            function: function,
            invoke: { try await function.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and throws an error if ``error``
    /// is not `nil`.
    ///
    /// - Parameter arguments: The arguments with which the function is being
    ///   invoked.
    /// - Throws: ``error``, if it is not `nil`.
    private func invoke(_ arguments: Arguments) async throws {
        self.callCount += 1
        self.invocations.append(arguments)

        guard let error = self.error else {
            return
        }

        self.errors.append(error)

        throw error
    }
}
