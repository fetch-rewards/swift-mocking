//
//  MockVoidAsyncFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's void, async
/// function without parameters.
public final class MockVoidAsyncFunctionWithoutParameters {

    // MARK: Properties

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    // MARK: Initializers

    /// Creates a void, async function without parameters.
    private init() {}

    // MARK: Factories

    /// Creates a function and an async closure for invoking the function,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidAsyncFunctionWithoutParameters.makeFunction()
    ///
    /// public var _logOut: MockVoidAsyncFunctionWithoutParameters {
    ///     self.__logOut.function
    /// }
    ///
    /// public func logOut() async {
    ///     await self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a function and an async closure for
    ///   invoking the function.
    public static func makeFunction(
    ) -> (
        function: MockVoidAsyncFunctionWithoutParameters,
        invoke: () async -> Void
    ) {
        let function = Self()

        return (
            function: function,
            invoke: { await function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function.
    private func invoke() async {
        self.callCount += 1
    }
}
