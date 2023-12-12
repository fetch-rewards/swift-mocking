//
//  MockVoidThrowingFunctionWithParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's void,
/// throwing function with parameters.
public final class MockVoidThrowingFunctionWithParameters<Arguments> {

    // MARK: Properties

    /// The error thrown by the function.
    public var error: Error?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The last arguments with which the function has been invoked.
    public var lastInvocation: Arguments? {
        self.invocations.last
    }

    /// All the errors that have been thrown by the function.
    public private(set) var thrownErrors: [Error] = []

    /// The last error thrown by the function.
    public var lastThrownError: Error? {
        self.thrownErrors.last
    }

    // MARK: Initializers

    /// Creates a void, throwing function with parameters.
    private init() {}

    // MARK: Factories

    /// Creates a function and a throwing closure for invoking the function,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidThrowingFunctionWithParameters<(String, String)>.makeFunction()
    ///
    /// public var _logIn: MockVoidThrowingFunctionWithParameters<(String, String)> {
    ///     self.__logIn.function
    /// }
    ///
    /// public func logIn(username: String, password: String) throws {
    ///     try self.__logIn.invoke((username, password))
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a function and a throwing closure for
    ///   invoking the function.
    public static func makeFunction(
    ) -> (
        function: MockVoidThrowingFunctionWithParameters,
        invoke: (Arguments) throws -> Void
    ) {
        let function = MockVoidThrowingFunctionWithParameters()

        return (
            function: function,
            invoke: { try function.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and throws an error if ``error``
    /// is not `nil`.
    ///
    /// - Parameter arguments: The arguments with which the function is being
    ///   invoked.
    /// - Throws: ``error``, if it is not `nil`.
    private func invoke(_ arguments: Arguments) throws {
        self.callCount += 1
        self.invocations.append(arguments)

        guard let error = self.error else {
            return
        }

        self.thrownErrors.append(error)

        throw error
    }
}
