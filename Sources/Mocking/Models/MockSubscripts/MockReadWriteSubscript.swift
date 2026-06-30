//
//  MockReadWriteSubscript.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Locking

/// A mock subscript that contains implementation details and invocation records
/// for a read-write subscript.
public final class MockReadWriteSubscript<Arguments, Value> {

    // MARK: Properties

    /// The subscript's getter.
    @Locked(.unchecked)
    public var getter: MockSubscriptGetter<Arguments, Value>

    /// The subscript's setter.
    @Locked(.unchecked)
    public var setter = MockSubscriptSetter<Arguments, Value>()

    // MARK: Initializers

    /// Creates a mock subscript that contains implementation details and
    /// invocation records for a read-write subscript.
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    private init(exposedSubscriptDescription: MockImplementationDescription) {
        self.getter = MockSubscriptGetter(
            exposedSubscriptDescription: exposedSubscriptDescription
        )
    }

    // MARK: Factories

    /// Creates a mock subscript, a closure for invoking the mock subscript's
    /// getter, a closure for invoking the mock subscript's setter, and a closure
    /// for resetting the mock subscript's getter and setter, returning them in a
    /// labeled tuple.
    ///
    /// ```swift
    /// private let __subscript = MockReadWriteSubscript<String, String?>.makeSubscript(
    ///     exposedSubscriptDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_subscript"
    ///     )
    /// )
    ///
    /// public var _subscript: MockReadWriteSubscript<String, String?> {
    ///     self.__subscript.`subscript`
    /// }
    ///
    /// public subscript(key: String) -> String? {
    ///     get {
    ///         self.__subscript.get(key)
    ///     }
    ///
    ///     set {
    ///         self.__subscript.set(key, newValue)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    /// - Returns: A tuple containing a mock subscript, a closure for invoking
    ///   the mock subscript's getter, a closure for invoking the mock subscript's
    ///   setter, and a closure for resetting the mock subscript's getter and
    ///   setter.
    public static func makeSubscript(
        exposedSubscriptDescription: MockImplementationDescription
    ) -> (
        subscript: MockReadWriteSubscript,
        get: (Arguments) -> Value,
        set: (Arguments, Value) -> Void,
        reset: () -> Void
    ) {
        let mock = MockReadWriteSubscript(
            exposedSubscriptDescription: exposedSubscriptDescription
        )

        return (
            subscript: mock,
            get: mock.getter.get,
            set: mock.setter.set,
            reset: mock.reset
        )
    }

    // MARK: Reset

    /// Resets the subscript's getter and setter.
    private func reset() {
        self.getter.reset()
        self.setter.reset()
    }
}

// MARK: - Sendable

extension MockReadWriteSubscript: Sendable where Arguments: Sendable, Value: Sendable {

    // MARK: Factories

    /// Creates a mock subscript, a closure for invoking the mock subscript's
    /// getter, a closure for invoking the mock subscript's setter, and a closure
    /// for resetting the mock subscript's getter and setter, returning them in a
    /// labeled tuple.
    ///
    /// ```swift
    /// private let __subscript = MockReadWriteSubscript<String, String?>.makeSubscript(
    ///     exposedSubscriptDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_subscript"
    ///     )
    /// )
    ///
    /// public var _subscript: MockReadWriteSubscript<String, String?> {
    ///     self.__subscript.`subscript`
    /// }
    ///
    /// public subscript(key: String) -> String? {
    ///     get {
    ///         self.__subscript.get(key)
    ///     }
    ///
    ///     set {
    ///         self.__subscript.set(key, newValue)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter exposedSubscriptDescription: The description of the mock's
    ///   exposed subscript.
    /// - Returns: A tuple containing a mock subscript, a closure for invoking
    ///   the mock subscript's getter, a closure for invoking the mock subscript's
    ///   setter, and a closure for resetting the mock subscript's getter and
    ///   setter.
    public static func makeSubscript(
        exposedSubscriptDescription: MockImplementationDescription
    ) -> (
        subscript: MockReadWriteSubscript,
        get: @Sendable (Arguments) -> Value,
        set: @Sendable (Arguments, Value) -> Void,
        reset: @Sendable () -> Void
    ) {
        let mock = MockReadWriteSubscript(
            exposedSubscriptDescription: exposedSubscriptDescription
        )

        return (
            subscript: mock,
            get: mock.getter.get,
            set: mock.setter.set,
            reset: mock.reset
        )
    }
}
