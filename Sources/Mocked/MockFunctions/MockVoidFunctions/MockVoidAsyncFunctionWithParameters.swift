//
//  MockVoidAsyncFunctionWithParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's void, async
/// function with parameters.
public final class MockVoidAsyncFunctionWithParameters<Arguments> {

    // MARK: Properties

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The last arguments with which the function has been invoked.
    public var lastInvocation: Arguments? {
        self.invocations.last
    }

    // MARK: Initializers

    /// Creates a void, async function with parameters.
    private init() {}

    // MARK: Factories

    /// Creates a function and an async closure for invoking the function,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidAsyncFunctionWithParameters<(String, String)>.makeFunction()
    ///
    /// public var _logIn: MockVoidAsyncFunctionWithParameters<(String, String)> {
    ///     self.__logIn.function
    /// }
    ///
    /// public func logIn(username: String, password: String) async {
    ///     await self.__logIn.invoke((username, password))
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a function and an async closure for
    ///   invoking the function.
    public static func makeFunction(
    ) -> (
        function: MockVoidAsyncFunctionWithParameters,
        invoke: (Arguments) async -> Void
    ) {
        let function = MockVoidAsyncFunctionWithParameters()

        return (
            function: function,
            invoke: { await function.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function.
    ///
    /// - Parameter arguments: The arguments with which the function is being
    ///   invoked.
    private func invoke(_ arguments: Arguments) async {
        self.callCount += 1
        self.invocations.append(arguments)
    }
}
