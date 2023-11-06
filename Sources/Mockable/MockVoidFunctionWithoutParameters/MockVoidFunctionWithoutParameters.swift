//
//  MockVoidFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's void function that
/// does not have parameters.
public struct MockVoidFunctionWithoutParameters {

    // MARK: Properties

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    // MARK: Initializers

    /// Creates a void function without parameters.
    private init() {}

    // MARK: Factories

    public static func makeFunction(
    ) -> (
        function: Self,
        invoke: () -> Void
    ) {
        var function = Self()

        return (
            function,
            { function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function.
    ///
    private mutating func invoke() {
        self.callCount += 1
    }
}
