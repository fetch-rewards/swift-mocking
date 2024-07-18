//
//  MockVoidMethodWithoutParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's void method
/// without parameters.
public final class MockVoidMethodWithoutParameters {

    // MARK: Properties

    /// The method's implementation.
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    public private(set) var callCount: Int = .zero

    // MARK: Initializers

    /// Creates a void method without parameters.
    private init() {}

    // MARK: Factories

    /// Creates a method and a closure for invoking the method, returning them
    /// in a labeled tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidMethodWithoutParameters.makeMethod()
    ///
    /// public var _logOut: MockVoidMethodWithoutParameters {
    ///     self.__logOut.method
    /// }
    ///
    /// public func logOut() {
    ///     self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a method and a closure for invoking the
    ///   method.
    public static func makeMethod(
    ) -> (
        method: MockVoidMethodWithoutParameters,
        invoke: () -> Void
    ) {
        let method = MockVoidMethodWithoutParameters()

        return (
            method: method,
            invoke: { method.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes ``implementation``.
    private func invoke() {
        self.callCount += 1
        self.implementation()
    }
}
