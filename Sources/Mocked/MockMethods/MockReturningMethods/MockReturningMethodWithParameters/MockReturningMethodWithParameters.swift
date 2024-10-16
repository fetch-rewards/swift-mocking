//
//  MockReturningMethodWithParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// The implementation details and invocation records for a mock's returning
/// method with parameters.
public final class MockReturningMethodWithParameters<Arguments, ReturnValue> {

    // MARK: Properties

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    @Locked(.unchecked)
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the method has been invoked.
    @Locked(.unchecked)
    public private(set) var invocations: [Arguments] = []

    /// The last arguments with which the method has been invoked.
    public var lastInvocation: Arguments? {
        self.invocations.last
    }

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

    /// Creates a returning method with parameters.
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
    /// private let __user = MockReturningMethodWithParameters<(User.ID), User>.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReturningMethodWithParameters<(User.ID), User> {
    ///     self.__user.method
    /// }
    ///
    /// public func user(id: User.ID) -> User {
    ///     self.__user.invoke((id))
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
        method: MockReturningMethodWithParameters,
        invoke: (Arguments) -> ReturnValue
    ) {
        let method = MockReturningMethodWithParameters(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            invoke: { method.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes ``implementation``.
    ///
    /// - Parameter arguments: The arguments with which the method is being
    ///   invoked.
    /// - Returns: A value, if ``implementation`` is
    ///   ``Implementation-swift.enum/uncheckedReturns(_:)-swift.enum.case`` or
    ///   ``Implementation-swift.enum/uncheckedReturns(_:)-swift.type.method``.
    private func invoke(_ arguments: Arguments) -> ReturnValue {
        self.callCount += 1
        self.invocations.append(arguments)

        let returnValue = self.implementation(
            arguments: arguments,
            description: self.exposedMethodDescription
        )

        self.returnedValues.append(returnValue)

        return returnValue
    }
}

// MARK: - Sendable

extension MockReturningMethodWithParameters: Sendable
where Arguments: Sendable, ReturnValue: Sendable {}
