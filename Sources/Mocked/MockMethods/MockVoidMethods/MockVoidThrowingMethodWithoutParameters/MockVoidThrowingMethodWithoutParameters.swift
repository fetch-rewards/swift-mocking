//
//  MockVoidThrowingMethodWithoutParameters.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The implementation details and invocation records for a mock's void,
/// throwing method without parameters.
public final class MockVoidThrowingMethodWithoutParameters {

    // MARK: Properties

    /// The method's implementation.
    public var implementation: Implementation = .unimplemented

    /// The number of times the method has been called.
    public private(set) var callCount: Int = .zero

    /// All the errors that have been thrown by the method.
    public private(set) var thrownErrors: [Error] = []

    /// The last error thrown by the method.
    public var lastThrownError: Error? {
        self.thrownErrors.last
    }

    // MARK: Initializers

    /// Creates a void, throwing method without parameters.
    private init() {}

    // MARK: Factories

    /// Creates a method and a throwing closure for invoking the method,
    /// returning them in a labeled tuple.
    ///
    /// ```swift
    /// private let __logOut = MockVoidThrowingMethodWithoutParameters.makeMethod()
    ///
    /// public var _logOut: MockVoidThrowingMethodWithoutParameters {
    ///     self.__logOut.method
    /// }
    ///
    /// public func logOut() throws {
    ///     try self.__logOut.invoke()
    /// }
    /// ```
    ///
    /// - Returns: A tuple containing a method and a throwing closure for
    ///   invoking the method.
    public static func makeMethod(
    ) -> (
        method: MockVoidThrowingMethodWithoutParameters,
        invoke: () throws -> Void
    ) {
        let method = MockVoidThrowingMethodWithoutParameters()

        return (
            method: method,
            invoke: { try method.invoke() }
        )
    }

    // MARK: Invoke

    /// Records the invocation of the method and invokes ``implementation``.
    ///
    /// - Throws: An error, if ``implementation`` is
    ///   ``Implementation-swift.enum/throws(_:)-swift.enum.case`` or
    ///   ``Implementation-swift.enum/throws(_:)-swift.type.method``.
    private func invoke() throws {
        self.callCount += 1

        do {
            try self.implementation()
        } catch {
            self.thrownErrors.append(error)
            throw error
        }
    }
}
