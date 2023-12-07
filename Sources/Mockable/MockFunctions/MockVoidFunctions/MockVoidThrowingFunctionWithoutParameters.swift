//
//  MockVoidThrowingFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's void,
/// throwing function without parameters.
public final class MockVoidThrowingFunctionWithoutParameters {

    // MARK: Properties

    /// The error thrown by the function.
    public var error: Error?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the errors that have been thrown by the function.
    public private(set) var errors: [Error] = []

    // MARK: Initializers

    /// Creates a void, throwing function without parameters.
    private init() {}

    // MARK: Factories

    /// Creates a function and a throwing closure for invoking the function,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidThrowingFunctionWithoutParameters.makeFunction()
    ///
    /// public var _logOut: MockVoidThrowingFunctionWithoutParameters {
    ///     self.__logOut.function
    /// }
    ///
    /// public func logOut() throws {
    ///     try self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a function and a throwing closure for
    ///   invoking the function.
    public static func makeFunction(
    ) -> (
        function: MockVoidThrowingFunctionWithoutParameters,
        invoke: () throws -> Void
    ) {
        let function = Self()

        return (
            function: function,
            invoke: { try function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and throws an error if ``error``
    /// is not `nil`.
    ///
    /// - Throws: ``error``, if it is not `nil`.
    private func invoke() throws {
        self.callCount += 1

        guard let error = self.error else {
            return
        }

        self.errors.append(error)

        throw error
    }
}
