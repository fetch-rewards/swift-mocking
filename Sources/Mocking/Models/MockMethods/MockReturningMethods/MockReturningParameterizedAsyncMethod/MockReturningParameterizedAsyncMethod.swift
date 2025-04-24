//
//  MockReturningParameterizedAsyncMethod.swift
//  Mocking
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Synchronization

/// A mock method that contains implementation details and invocation records
/// for a returning, parameterized, async method.
public final class MockReturningParameterizedAsyncMethod<
    Implementation: MockReturningParameterizedAsyncMethodImplementation
> {

    // MARK: Typealiases

    /// The method's arguments type.
    public typealias Arguments = Implementation.Arguments

    /// The method's return value type.
    public typealias ReturnValue = Implementation.ReturnValue

    /// The method's closure type.
    public typealias Closure = Implementation.Closure

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

    /// Creates a mock method that contains implementation details and
    /// invocation records for a returning, parameterized, async method.
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    private init(exposedMethodDescription: MockImplementationDescription) {
        self.exposedMethodDescription = exposedMethodDescription
    }

    // MARK: Factories

    /// Creates a mock method, a closure for recording an invocation's input, a
    /// closure for retrieving the mock method's implementation as a closure, a
    /// closure for recording an invocation's output, and a closure for
    /// resetting the mock method, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReturningParameterizedAsyncMethod<
    ///     UserImplementation
    /// >.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReturningParameterizedAsyncMethod<
    ///     UserImplementation
    /// > {
    ///     self.__user.method
    /// }
    ///
    /// public func user(id: User.ID) async -> User {
    ///     self.__user.recordInput((id))
    ///
    ///     let invoke = self.__user.closure()
    ///     let returnValue = await invoke(id)
    ///
    ///     self.__user.recordOutput(returnValue)
    ///
    ///     return returnValue
    /// }
    /// ```
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    /// - Returns: A tuple containing a mock method, a closure for recording an
    ///   invocation's input, a closure for retrieving the mock method's
    ///   implementation as a closure, a closure for recording an invocation's
    ///   output, and a closure for resetting the mock method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningParameterizedAsyncMethod,
        recordInput: (Arguments) -> Void,
        closure: () -> Closure,
        recordOutput: (ReturnValue) -> Void,
        reset: () -> Void
    ) {
        let method = MockReturningParameterizedAsyncMethod(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            recordInput: method.recordInput,
            closure: method.closure,
            recordOutput: method.recordOutput,
            reset: method.reset
        )
    }

    // MARK: Record

    /// Records the input of an invocation of the method.
    ///
    /// - Parameter arguments: The arguments with which the method is being
    ///   invoked.
    private func recordInput(arguments: Arguments) {
        self.callCount += 1
        self.invocations.append(arguments)
    }

    /// Returns the method's implementation as a closure, or triggers a fatal
    /// error if unimplemented.
    ///
    /// - Returns: The method's implementation as a closure.
    private func closure() -> Closure {
        guard let closure = self.implementation._closure else {
            fatalError("Unimplemented: \(self.exposedMethodDescription)")
        }

        return closure
    }

    /// Records the output of an invocation of the method.
    ///
    /// - Parameter returnValue: The value returned by the method.
    private func recordOutput(returnValue: ReturnValue) {
        self.returnedValues.append(returnValue)
    }

    // MARK: Reset

    /// Resets the method's implementation and invocation records.
    private func reset() {
        self.implementation = .unimplemented
        self.callCount = .zero
        self.invocations.removeAll()
        self.returnedValues.removeAll()
    }
}

// MARK: - Sendable

extension MockReturningParameterizedAsyncMethod: Sendable
    where Arguments: Sendable,
          ReturnValue: Sendable
{

    // MARK: Factories

    /// Creates a mock method, a closure for recording an invocation's input, a
    /// closure for retrieving the mock method's implementation as a closure, a
    /// closure for recording an invocation's output, and a closure for
    /// resetting the mock method, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReturningParameterizedAsyncMethod<
    ///     UserImplementation
    /// >.makeMethod(
    ///     exposedMethodDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReturningParameterizedAsyncMethod<
    ///     UserImplementation
    /// > {
    ///     self.__user.method
    /// }
    ///
    /// public func user(id: User.ID) async -> User {
    ///     self.__user.recordInput((id))
    ///
    ///     let invoke = self.__user.closure()
    ///     let returnValue = await invoke(id)
    ///
    ///     self.__user.recordOutput(returnValue)
    ///
    ///     return returnValue
    /// }
    /// ```
    ///
    /// - Parameter exposedMethodDescription: The description of the mock's
    ///   exposed method.
    /// - Returns: A tuple containing a mock method, a closure for recording an
    ///   invocation's input, a closure for retrieving the mock method's
    ///   implementation as a closure, a closure for recording an invocation's
    ///   output, and a closure for resetting the mock method.
    public static func makeMethod(
        exposedMethodDescription: MockImplementationDescription
    ) -> (
        method: MockReturningParameterizedAsyncMethod,
        recordInput: @Sendable (Arguments) -> Void,
        closure: @Sendable () -> Closure,
        recordOutput: @Sendable (ReturnValue) -> Void,
        reset: @Sendable () -> Void
    ) {
        let method = MockReturningParameterizedAsyncMethod(
            exposedMethodDescription: exposedMethodDescription
        )

        return (
            method: method,
            recordInput: method.recordInput,
            closure: method.closure,
            recordOutput: method.recordOutput,
            reset: method.reset
        )
    }
}
