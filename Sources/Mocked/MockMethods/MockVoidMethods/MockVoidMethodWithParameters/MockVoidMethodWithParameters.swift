//
//  MockVoidMethodWithParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// The implementation details and invocation records for a mock's void method
/// with parameters.
public final class MockVoidMethodWithParameters<Arguments> {

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

    // MARK: Initializers

    /// Creates a void method with parameters.
    private init() {}

    // MARK: Factories

    /// Creates a method, a closure for invoking the method, and a closure for
    /// resetting the method, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidMethodWithParameters<(String, String)>.makeMethod()
    ///
    /// public var _logIn: MockVoidMethodWithParameters<(String, String)> {
    ///     self.__logIn.method
    /// }
    ///
    /// public func logIn(username: String, password: String) {
    ///     self.__logIn.invoke((username, password))
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a method, a closure for invoking the
    ///   method, and a closure for resetting the method.
    public static func makeMethod(
    ) -> (
        method: MockVoidMethodWithParameters,
        invoke: (Arguments) -> Void,
        reset: () -> Void
    ) {
        let method = MockVoidMethodWithParameters()

        return (
            method: method,
            invoke: { method.invoke($0) },
            reset: { method.reset() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes ``implementation``.
    ///
    /// - Parameter arguments: The arguments with which the method is being
    ///   invoked.
    private func invoke(_ arguments: Arguments) {
        self.callCount += 1
        self.invocations.append(arguments)
        self.implementation(arguments: arguments)
    }

    // MARK: Reset

    /// Resets the method's implementation and invocation records.
    private func reset() {
        self.implementation = .unimplemented
        self.callCount = .zero
        self.invocations.removeAll()
    }
}

// MARK: - Sendable

extension MockVoidMethodWithParameters: Sendable
where Arguments: Sendable {

    // MARK: Factories

    /// Creates a method, a closure for invoking the method, and a closure for
    /// resetting the method, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidMethodWithParameters<(String, String)>.makeMethod()
    ///
    /// public var _logIn: MockVoidMethodWithParameters<(String, String)> {
    ///     self.__logIn.method
    /// }
    ///
    /// public func logIn(username: String, password: String) {
    ///     self.__logIn.invoke((username, password))
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a method, a closure for invoking the
    ///   method, and a closure for resetting the method.
    public static func makeMethod(
    ) -> (
        method: MockVoidMethodWithParameters,
        invoke: @Sendable (Arguments) -> Void,
        reset: @Sendable () -> Void
    ) {
        let method = MockVoidMethodWithParameters()

        return (
            method: method,
            invoke: { method.invoke($0) },
            reset: { method.reset() }
        )
    }
}
