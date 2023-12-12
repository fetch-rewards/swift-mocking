//
//  MockVoidAsyncThrowingFunctionWithoutParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's void, async,
/// throwing function without parameters.
public final class MockVoidAsyncThrowingFunctionWithoutParameters {

    // MARK: Properties

    /// The error thrown by the function.
    public var error: Error?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the errors that have been thrown by the function.
    public private(set) var errors: [Error] = []

    /// The latest error thrown by the function.
    public var latestError: Error? {
        self.errors.last
    }

    // MARK: Initializers

    /// Creates a void, async, throwing function without parameters.
    private init() {}

    // MARK: Factories

    /// Creates a function and an async throwing closure for invoking the
    /// function, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidAsyncThrowingFunctionWithoutParameters.makeFunction()
    ///
    /// public var _logOut: MockVoidAsyncThrowingFunctionWithoutParameters {
    ///     self.__logOut.function
    /// }
    ///
    /// public func logOut() async throws {
    ///     try await self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a function and an async throwing closure
    ///   for invoking the function.
    public static func makeFunction(
    ) -> (
        function: MockVoidAsyncThrowingFunctionWithoutParameters,
        invoke: () async throws -> Void
    ) {
        let function = MockVoidAsyncThrowingFunctionWithoutParameters()

        return (
            function: function,
            invoke: { try await function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and throws an error if ``error``
    /// is not `nil`.
    ///
    /// - Throws: ``error``, if it is not `nil`.
    private func invoke() async throws {
        self.callCount += 1

        guard let error = self.error else {
            return
        }

        self.errors.append(error)

        throw error
    }
}
