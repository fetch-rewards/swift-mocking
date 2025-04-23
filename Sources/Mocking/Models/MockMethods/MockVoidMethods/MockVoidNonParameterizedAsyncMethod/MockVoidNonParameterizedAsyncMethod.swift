//
//  MockVoidNonParameterizedAsyncMethod.swift
//  Mocking
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// A mock method that contains implementation details and invocation records
/// for a void, non-parameterized, async method.
public final class MockVoidNonParameterizedAsyncMethod: Sendable {

    // MARK: Properties

    /// The method's implementation.
    @Locked(.unchecked)
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    @Locked(.unchecked)
    public private(set) var callCount: Int = .zero

    // MARK: Initializers

    /// Creates a mock method that contains implementation details and
    /// invocation records for a void, non-parameterized, async method.
    private init() {}

    // MARK: Factories

    /// Creates a mock method, an async closure for invoking the mock method,
    /// and a closure for resetting the mock method, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidNonParameterizedAsyncMethod.makeMethod()
    ///
    /// public var _logOut: MockVoidNonParameterizedAsyncMethod {
    ///     self.__logOut.method
    /// }
    ///
    /// public func logOut() async {
    ///     await self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a mock method, an async closure for
    ///   invoking the mock method, and a closure for resetting the mock method,
    ///   returning them in a labeled tuple.
    public static func makeMethod(
    ) -> (
        method: MockVoidNonParameterizedAsyncMethod,
        invoke: @Sendable () async -> Void,
        reset: @Sendable () -> Void
    ) {
        let method = MockVoidNonParameterizedAsyncMethod()

        return (
            method: method,
            invoke: method.invoke,
            reset: method.reset
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes
    /// ``implementation-swift.property``.
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
