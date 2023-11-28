//
//  MockReturningAsyncThrowingFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation and invocation records for a mock's returning, async,
/// throwing function without parameters.
public final class MockReturningAsyncThrowingFunctionWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The function's implementation.
    public var implementation: MockAsyncThrowingImplementation<ReturnValue> = .unimplemented

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [Result<ReturnValue, Error>] = []

    /// The latest value returned by the function.
    public var latestReturnValue: Result<ReturnValue, Error>? {
        self.returnValues.last
    }

    /// The description of the mock's exposed function.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed function needs an implementation for the test
    /// to succeed.
    private let description: MockImplementationDescription

    // MARK: Initializers

    /// Creates a returning, async, throwing function without parameters.
    ///
    /// - Parameter description: The description of the mock's exposed function.
    private init(description: MockImplementationDescription) {
        self.description = description
    }

    // MARK: Factories

    /// Creates a function and an async, throwing closure for invoking the
    /// function, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __items = MockReturningAsyncThrowingFunctionWithoutParameters<Items>.makeFunction(
    ///     description: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_items"
    ///     )
    /// )
    /// public var _items: MockReturningAsyncThrowingFunctionWithoutParameters<Items> {
    ///     self.__items.function
    /// }
    /// ```
    ///
    /// - Parameter description: The description of the mock's exposed function.
    /// - Returns: A tuple containing a function and an async, throwing closure
    ///   for invoking the function.
    public static func makeFunction(
        description: MockImplementationDescription
    ) -> (
        function: MockReturningAsyncThrowingFunctionWithoutParameters,
        invoke: () async throws -> ReturnValue
    ) {
        let function = MockReturningAsyncThrowingFunctionWithoutParameters(description: description)

        return (
            function: function,
            invoke: { try await function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value or throws an error.
    ///
    /// - Throws: An error, if ``returnValue`` is `.failure`.
    /// - Returns: The function's return value.
    private func invoke() async throws -> ReturnValue {
        self.callCount += 1

        let returnValue = await Result {
            try await self.implementation(description: self.description)
        }

        self.returnValues.append(returnValue)

        return try returnValue.get()
    }
}
