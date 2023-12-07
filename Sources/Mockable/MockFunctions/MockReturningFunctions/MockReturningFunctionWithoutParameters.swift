//
//  MockReturningFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's returning
/// function without parameters.
public final class MockReturningFunctionWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The function's implementation.
    public var implementation: MockImplementation<ReturnValue> = .unimplemented

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [ReturnValue] = []

    /// The latest value returned by the function.
    public var latestReturnValue: ReturnValue? {
        self.returnValues.last
    }

    /// The description of the mock's exposed function.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed function needs an implementation for the test
    /// to succeed.
    private let exposedFunctionDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a returning function without parameters.
    ///
    /// - Parameter exposedFunctionDescription: The description of the mock's
    ///   exposed function.
    private init(exposedFunctionDescription: MockImplementationDescription) {
        self.exposedFunctionDescription = exposedFunctionDescription
    }

    // MARK: Factories

    /// Creates a function and a closure for invoking the function, returning
    /// them in a labeled tuple.
    ///
    /// ```swift
    /// private let __users = MockReturningFunctionWithoutParameters<[User]>.makeFunction(
    ///     exposedFunctionDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_users"
    ///     )
    /// )
    ///
    /// public var _users: MockReturningFunctionWithoutParameters<[User]> {
    ///     self.__users.function
    /// }
    ///
    /// public func users() -> [User] {
    ///     self.__users.invoke()
    /// }
    /// ```
    ///
    /// - Parameter exposedFunctionDescription: The description of the mock's
    ///   exposed function.
    /// - Returns: A tuple containing a function and a closure for invoking the
    ///   function.
    public static func makeFunction(
        exposedFunctionDescription: MockImplementationDescription
    ) -> (
        function: MockReturningFunctionWithoutParameters,
        invoke: () -> ReturnValue
    ) {
        let function = MockReturningFunctionWithoutParameters(
            exposedFunctionDescription: exposedFunctionDescription
        )

        return (
            function: function,
            invoke: { function.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value.
    ///
    /// - Returns: The function's return value.
    private func invoke() -> ReturnValue {
        self.callCount += 1

        let returnValue = self.implementation(description: self.exposedFunctionDescription)

        self.returnValues.append(returnValue)

        return returnValue
    }
}
