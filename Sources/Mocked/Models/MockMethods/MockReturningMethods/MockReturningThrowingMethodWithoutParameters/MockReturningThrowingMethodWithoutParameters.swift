//
//  MockReturningThrowingMethodWithoutParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// The implementation details and invocation records for a mock's returning,
/// throwing method without parameters.
public final class MockReturningThrowingMethodWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    @Locked(.unchecked)
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the method.
    @Locked(.unchecked)
    public private(set) var returnedValues: [Result<ReturnValue, any Error>] = []

    /// The last value returned by the method.
    public var lastReturnedValue: Result<ReturnValue, any Error>? {
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

    /// Creates a method, a throwing closure for invoking the method, and a
    /// closure for resetting the method, returning them in a labeled tuple.
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
    /// - Returns: A tuple containing a method, a throwing closure for invoking
    ///   the method, and a closure for resetting the method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningThrowingMethodWithoutParameters,
        invoke: () throws -> ReturnValue,
        reset: () -> Void
    ) {
        let method = MockReturningThrowingMethodWithoutParameters(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            invoke: { try method.invoke() },
            reset: { method.reset() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes ``implementation``.
    ///
    /// - Throws: An error, if ``implementation`` is
    ///   ``Implementation-swift.enum/uncheckedThrows(_:)-swift.enum.case`` or
    ///   ``Implementation-swift.enum/uncheckedThrows(_:)-swift.type.method``.
    /// - Returns: A value, if ``implementation`` is
    ///   ``Implementation-swift.enum/uncheckedReturns(_:)-swift.enum.case`` or
    ///   ``Implementation-swift.enum/uncheckedReturns(_:)-swift.type.method``.
    private func invoke() throws -> ReturnValue {
        self.callCount += 1

        let returnValue = Result {
            try self.implementation(description: self.exposedMethodDescription)
        }

        self.returnedValues.append(returnValue)

        return try returnValue.get()
    }

    // MARK: Reset

    /// Resets the method's implementation and invocation records.
    private func reset() {
        self.implementation = .unimplemented
        self.callCount = .zero
        self.returnedValues.removeAll()
    }
}

// MARK: - Sendable

extension MockReturningThrowingMethodWithoutParameters: Sendable
    where ReturnValue: Sendable
{

    // MARK: Factories

    /// Creates a method, a throwing closure for invoking the method, and a
    /// closure for resetting the method, returning them in a labeled tuple.
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
    /// - Returns: A tuple containing a method, a throwing closure for invoking
    ///   the method, and a closure for resetting the method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningThrowingMethodWithoutParameters,
        invoke: @Sendable () throws -> ReturnValue,
        reset: @Sendable () -> Void
    ) {
        let method = MockReturningThrowingMethodWithoutParameters(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            invoke: { try method.invoke() },
            reset: { method.reset() }
        )
    }
}
