//
//  MockVoidAsyncMethodWithParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// The implementation details and invocation records for a mock's void, async
/// method with parameters.
public final class MockVoidAsyncMethodWithParameters<Arguments> {

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

    /// Creates a void, async method with parameters.
    private init() {}

    // MARK: Factories

    /// Creates a method and an async closure for invoking the method, returning
    /// them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logIn = MockVoidAsyncMethodWithParameters<(String, String)>.makeMethod()
    ///
    /// public var _logIn: MockVoidAsyncMethodWithParameters<(String, String)> {
    ///     self.__logIn.method
    /// }
    ///
    /// public func logIn(username: String, password: String) async {
    ///     await self.__logIn.invoke((username, password))
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a method and an async closure for invoking
    ///   the method.
    public static func makeMethod(
    ) -> (
        method: MockVoidAsyncMethodWithParameters,
        invoke: (Arguments) async -> Void
    ) {
        let method = MockVoidAsyncMethodWithParameters()

        return (
            method: method,
            invoke: { await method.invoke($0) }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes ``implementation``.
    ///
    /// - Parameter arguments: The arguments with which the method is being
    ///   invoked.
    private func invoke(_ arguments: Arguments) async {
        self.callCount += 1
        self.invocations.append(arguments)
        await self.implementation(arguments: arguments)
    }
}

// MARK: - Sendable

extension MockVoidAsyncMethodWithParameters: Sendable
where Arguments: Sendable {}
