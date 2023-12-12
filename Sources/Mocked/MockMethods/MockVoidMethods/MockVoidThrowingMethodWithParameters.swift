//
//  MockVoidThrowingMethodWithParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's void,
/// throwing method with parameters.
public final class MockVoidThrowingMethodWithParameters<Arguments> {

    // MARK: Properties

    /// The error thrown by the method.
    public var error: Error?

    /// The number of times the method has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the method has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The last arguments with which the method has been invoked.
    public var lastInvocation: Arguments? {
        self.invocations.last
    }

    /// All the errors that have been thrown by the method.
    public private(set) var thrownErrors: [Error] = []

    /// The last error thrown by the method.
    public var lastThrownError: Error? {
        self.thrownErrors.last
    }

    // MARK: Initializers

    /// Creates a void, throwing method with parameters.
    private init() {}

    // MARK: Factories

    /// Creates a method and a throwing closure for invoking the method,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidThrowingMethodWithParameters<(String, String)>.makeMethod()
    ///
    /// public var _logIn: MockVoidThrowingMethodWithParameters<(String, String)> {
    ///     self.__logIn.method
    /// }
    ///
    /// public func logIn(username: String, password: String) throws {
    ///     try self.__logIn.invoke((username, password))
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a method and a throwing closure for
    ///   invoking the method.
    public static func makeMethod(
    ) -> (
        method: MockVoidThrowingMethodWithParameters,
        invoke: (Arguments) throws -> Void
    ) {
        let method = MockVoidThrowingMethodWithParameters()

        return (
            method: method,
            invoke: { try method.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and throws an error if ``error`` is
    /// not `nil`.
    ///
    /// - Parameter arguments: The arguments with which the method is being
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
