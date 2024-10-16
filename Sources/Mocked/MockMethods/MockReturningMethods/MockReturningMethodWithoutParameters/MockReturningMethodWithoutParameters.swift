//
//  MockReturningMethodWithoutParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// The implementation details and invocation records for a mock's returning
/// method without parameters.
public final class MockReturningMethodWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    @Locked(.unchecked)
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the method.
    @Locked(.unchecked)
    public private(set) var returnedValues: [ReturnValue] = []

    /// The last value returned by the method.
    public var lastReturnedValue: ReturnValue? {
        self.returnedValues.last
    }

    /// The description of the mock's exposed method.
    ///
    /// This description is used when generating an `unimplemented` test failure
    /// to indicate which exposed method needs an implementation for the test to
    /// succeed.
    private let exposedMethodDescription: MockImplementationDescription

    // MARK: Initializers

    /// Creates a returning method without parameters.
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    private init(exposedMethodDescription: MockImplementationDescription) {
        self.exposedMethodDescription = exposedMethodDescription
    }

    // MARK: Factories

    /// Creates a method and a closure for invoking the method, returning them
    /// in a labeled tuple.
    ///
    /// ```swift
    /// private let __users = MockReturningMethodWithoutParameters<[User]>.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_users"
    ///     )
    /// )
    ///
    /// public var _users: MockReturningMethodWithoutParameters<[User]> {
    ///     self.__users.method
    /// }
    ///
    /// public func users() -> [User] {
    ///     self.__users.invoke()
    /// }
    /// ```
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    /// - Returns: A tuple containing a method and a closure for invoking the
    ///   method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningMethodWithoutParameters,
        invoke: () -> ReturnValue
    ) {
        let method = MockReturningMethodWithoutParameters(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            invoke: { method.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes ``implementation``.
    ///
    /// - Returns: A value, if ``implementation`` is
    ///   ``Implementation-swift.enum/uncheckedReturns(_:)-swift.enum.case`` or
    ///   ``Implementation-swift.enum/uncheckedReturns(_:)-swift.type.method``.
    private func invoke() -> ReturnValue {
        self.callCount += 1

        let returnValue = self.implementation(
            description: self.exposedMethodDescription
        )

        self.returnedValues.append(returnValue)

        return returnValue
    }
}

// MARK: - Sendable

extension MockReturningMethodWithoutParameters: Sendable
where ReturnValue: Sendable {

    // MARK: Factories

    /// Creates a method and a closure for invoking the method, returning them
    /// in a labeled tuple.
    ///
    /// ```swift
    /// private let __users = MockReturningMethodWithoutParameters<[User]>.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_users"
    ///     )
    /// )
    ///
    /// public var _users: MockReturningMethodWithoutParameters<[User]> {
    ///     self.__users.method
    /// }
    ///
    /// public func users() -> [User] {
    ///     self.__users.invoke()
    /// }
    /// ```
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    /// - Returns: A tuple containing a method and a closure for invoking the
    ///   method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningMethodWithoutParameters,
        invoke: @Sendable () -> ReturnValue
    ) {
        let method = MockReturningMethodWithoutParameters(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            invoke: { method.invoke() }
        )
    }
}
