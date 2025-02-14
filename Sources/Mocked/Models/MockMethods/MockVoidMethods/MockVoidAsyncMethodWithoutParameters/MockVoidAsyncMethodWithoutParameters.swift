//
//  MockVoidAsyncMethodWithoutParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// The implementation details and invocation records for a mock's void, async
/// method without parameters.
public final class MockVoidAsyncMethodWithoutParameters: Sendable {

    // MARK: Properties

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    @Locked(.unchecked)
    public private(set) var callCount: Int = .zero

    // MARK: Initializers

    /// Creates a void, async method without parameters.
    private init() {}

    // MARK: Factories

    /// Creates a method, an async closure for invoking the method, and a
    /// closure for resetting the method, returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidAsyncMethodWithoutParameters.makeMethod()
    ///
    /// public var _logOut: MockVoidAsyncMethodWithoutParameters {
    ///     self.__logOut.method
    /// }
    ///
    /// public func logOut() async {
    ///     await self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a method, an async closure for invoking
    ///   the method, and a closure for resetting the method.
    public static func makeMethod(
    ) -> (
        method: MockVoidAsyncMethodWithoutParameters,
        invoke: @Sendable () async -> Void,
        reset: @Sendable () -> Void
    ) {
        let method = MockVoidAsyncMethodWithoutParameters()

        return (
            method: method,
            invoke: { await method.invoke() },
            reset: { method.reset() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes ``implementation``.
    private func invoke() async {
        self.callCount += 1
        await self.implementation()
    }

    // MARK: Reset

    /// Resets the method's implementation and invocation records.
    private func reset() {
        self.implementation = .unimplemented
        self.callCount = .zero
    }
}
