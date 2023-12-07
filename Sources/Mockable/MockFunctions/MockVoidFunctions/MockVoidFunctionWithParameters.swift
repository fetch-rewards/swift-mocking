//
//  MockVoidFunctionWithParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation and invocation records for a mock's void function with
/// parameters.
public final class MockVoidFunctionWithParameters<Arguments> {

    // MARK: Properties

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The latest arguments with which the function has been invoked.
    public var latestInvocation: Arguments? {
        self.invocations.last
    }

    // MARK: Initializers

    /// Creates a void function with parameters.
    private init() {}

    // MARK: Factories

    /// Creates a function and a closure for invoking the function, returning
    /// them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidFunctionWithParameters<(String, String)>.makeFunction()
    ///
    /// public var _logIn: MockVoidFunctionWithParameters<(String, String)> {
    ///     self.__logIn.function
    /// }
    ///
    /// public func logIn(username: String, password: String) {
    ///     self.__logIn.invoke((username, password))
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a function and a closure for invoking the
    ///   function.
    public static func makeFunction(
    ) -> (
        function: MockVoidFunctionWithParameters,
        invoke: (Arguments) -> Void
    ) {
        let function = Self()

        return (
            function: function,
            invoke: { function.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function.
    ///
    /// - Parameter arguments: The arguments with which the function is being
    ///   invoked.
    private func invoke(_ arguments: Arguments) {
        self.callCount += 1
        self.invocations.append(arguments)
    }
}
