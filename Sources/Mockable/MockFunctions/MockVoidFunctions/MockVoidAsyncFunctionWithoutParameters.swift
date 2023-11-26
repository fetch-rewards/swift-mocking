//
//  MockVoidAsyncFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's void, async function
/// that does not have parameters.
public final class MockVoidAsyncFunctionWithoutParameters {

    // MARK: Properties

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    // MARK: Initializers

    /// Creates a void, async function without parameters.
    private init() {}

    // MARK: Factories

    /// Creates a new function and an async closure to invoke the function,
    /// returning them in a labeled tuple.
    ///
    /// - Returns: A tuple containing a new function and an async closure to
    ///   invoke the function.
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
    ///
    private func invoke() async {
        self.callCount += 1
    }
}
