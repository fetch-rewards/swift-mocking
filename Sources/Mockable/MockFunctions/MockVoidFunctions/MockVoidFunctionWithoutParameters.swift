//
//  MockVoidFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's void function
/// without parameters.
public final class MockVoidFunctionWithoutParameters {

    // MARK: Properties

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    // MARK: Initializers

    /// Creates a void function without parameters.
    private init() {}

    // MARK: Factories

    /// Creates a function and a closure for invoking the function, returning
    /// them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidFunctionWithoutParameters.makeFunction()
    ///
    /// public var _logOut: MockVoidFunctionWithoutParameters {
    ///     self.__logOut.function
    /// }
    ///
    /// public func logOut() {
    ///     self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a function and a closure for invoking the
    ///   function.
    public static func makeFunction(
    ) -> (
        function: MockVoidFunctionWithoutParameters,
        invoke: () -> Void
    ) {
        let function = MockVoidFunctionWithoutParameters()

        return (
            function: function,
            invoke: { function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function.
    private func invoke() {
        self.callCount += 1
    }
}
