//
//  MockReadWriteProperty.swift
//  Mocking
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// A mock property that contains implementation details and invocation records
/// for a read-write property.
public final class MockReadWriteProperty<Value> {

    // MARK: Properties

    /// The property's getter.
    @Locked(.unchecked)
    public var getter: MockPropertyGetter<Value>

    /// The property's setter.
    @Locked(.unchecked)
    public var setter = MockPropertySetter<Value>()

    // MARK: Initializers

    /// Creates a mock property that contains implementation details and
    /// invocation records for a read-write property.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    private init(exposedPropertyDescription: MockImplementationDescription) {
        self.getter = MockPropertyGetter(
            exposedPropertyDescription: exposedPropertyDescription
        )
    }

    // MARK: Factories

    /// Creates a mock property, a closure for invoking the mock property's
    /// getter, a closure for invoking the mock property's setter, and a closure
    /// for resetting the mock property's getter and setter, returning them in a
    /// labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReadWriteProperty<User>.makeProperty(
    ///     exposedPropertyDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReadWriteProperty<User> {
    ///     self.__user.property
    /// }
    ///
    /// public var user: User {
    ///     get {
    ///         self.__user.get()
    ///     }
    ///
    ///     set {
    ///         self.__user.set(newValue)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a mock property, a closure for invoking
    ///   the mock property's getter, a closure for invoking the mock property's
    ///   setter, and a closure for resetting the mock property's getter and
    ///   setter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadWriteProperty,
        get: () -> Value,
        set: (Value) -> Void,
        reset: () -> Void
    ) {
        let property = MockReadWriteProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: property.getter.get,
            set: property.setter.set,
            reset: property.reset
        )
    }

    // MARK: Reset

    /// Resets the property's getter and setter.
    private func reset() {
        self.getter.reset()
        self.setter.reset()
    }
}

// MARK: - Sendable

extension MockReadWriteProperty: Sendable where Value: Sendable {

    // MARK: Factories

    /// Creates a mock property, a closure for invoking the mock property's
    /// getter, a closure for invoking the mock property's setter, and a closure
    /// for resetting the mock property's getter and setter, returning them in a
    /// labeled tuple.
    ///
    /// ```swift
    /// private let __user = MockReadWriteProperty<User>.makeProperty(
    ///     exposedPropertyDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReadWriteProperty<User> {
    ///     self.__user.property
    /// }
    ///
    /// public var user: User {
    ///     get {
    ///         self.__user.get()
    ///     }
    ///
    ///     set {
    ///         self.__user.set(newValue)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a mock property, a closure for invoking
    ///   the mock property's getter, a closure for invoking the mock property's
    ///   setter, and a closure for resetting the mock property's getter and
    ///   setter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadWriteProperty,
        get: @Sendable () -> Value,
        set: @Sendable (Value) -> Void,
        reset: @Sendable () -> Void
    ) {
        let property = MockReadWriteProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: property.getter.get,
            set: property.setter.set,
            reset: property.reset
        )
    }
}
