//
//  MockReturningThrowingMethodWithoutParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's returning,
/// throwing method without parameters.
public final class MockReturningThrowingMethodWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The method's implementation.
    public var implementation: MockThrowingImplementation<ReturnValue> = .unimplemented

    /// The number of times the method has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the method.
    public private(set) var returnedValues: [Result<ReturnValue, Error>] = []

    /// The last value returned by the method.
    public var lastReturnedValue: Result<ReturnValue, Error>? {
        self.returnedValues.last
    }

    /// The description of the mock's exposed method.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed method needs an implementation for the test to
    /// succeed.
    private let exposedMethodDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a returning, throwing method without parameters.
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    private init(exposedMethodDescription: MockImplementationDescription) {
        self.exposedMethodDescription = exposedMethodDescription
    }

    // MARK: Factories

    /// Creates a method and a throwing closure for invoking the method,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __users = MockReturningThrowingMethodWithoutParameters<[User]>.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_users"
    ///     )
    /// )
    ///
    /// public var _users: MockReturningThrowingMethodWithoutParameters<[User]> {
    ///     self.__users.method
    /// }
    ///
    /// public func users() throws -> [User] {
    ///     try self.__users.invoke()
    /// }
    /// ```
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    /// - Returns: A tuple containing a method and a throwing closure for
    ///   invoking the method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningThrowingMethodWithoutParameters,
        invoke: () throws -> ReturnValue
    ) {
        let method = MockReturningThrowingMethodWithoutParameters(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            invoke: { try method.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and returns the method's return
    /// value or throws an error.
    ///
    /// - Throws: An error, if ``returnValue`` is `.failure`.
    /// - Returns: The method's return value.
    private func invoke() throws -> ReturnValue {
        self.callCount += 1

        let returnValue = Result {
            try self.implementation(description: self.exposedMethodDescription)
        }

        self.returnedValues.append(returnValue)

        return try returnValue.get()
    }
}
