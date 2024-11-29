//
//  MockReadOnlyProperty.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// The implementation details and invocation records for a mock's read-only
/// property.
public final class MockReadOnlyProperty<Value> {

    // MARK: Properties

    /// The property's getter.
    @Locked(.unchecked)
    public var getter: MockPropertyGetter<Value>

    // MARK: Initializers

    /// Creates a read-only property.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    private init(exposedPropertyDescription: MockImplementationDescription) {
        self.getter = MockPropertyGetter(
            exposedPropertyDescription: exposedPropertyDescription
        )
    }

    // MARK: Factories

    /// Creates a property, a closure for invoking the property's getter, and a
    /// closure for resetting the property's getter, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __user = MockReadOnlyProperty<User>.makeProperty(
    ///     exposedPropertyDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReadOnlyProperty<User> {
    ///     self.__user.property
    /// }
    ///
    /// public var user: User {
    ///     self.__user.get()
    /// }
    /// ```
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a property, a closure for invoking the
    ///   property's getter, and a closure for resetting the property's getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyProperty,
        get: () -> Value,
        reset: () -> Void
    ) {
        let property = MockReadOnlyProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: { property.getter.get() },
            reset: { property.reset() }
        )
    }

    // MARK: Reset

    /// Resets the property's getter.
    private func reset() {
        self.getter.reset()
    }
}

// MARK: - Sendable

extension MockReadOnlyProperty: Sendable
where Value: Sendable {

    // MARK: Factories

    /// Creates a property, a closure for invoking the property's getter, and a
    /// closure for resetting the property's getter, returning them in a labeled
    /// tuple.
    ///
    /// ```swift
    /// private let __user = MockReadOnlyProperty<User>.makeProperty(
    ///     exposedPropertyDescription: MockImplementationDescription(
    ///         type: Self.self,
    ///         member: "_user"
    ///     )
    /// )
    ///
    /// public var _user: MockReadOnlyProperty<User> {
    ///     self.__user.property
    /// }
    ///
    /// public var user: User {
    ///     self.__user.get()
    /// }
    /// ```
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a property, a closure for invoking the
    ///   property's getter, and a closure for resetting the property's getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyProperty,
        get: @Sendable () -> Value,
        reset: @Sendable () -> Void
    ) {
        let property = MockReadOnlyProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: { property.getter.get() },
            reset: { property.reset() }
        )
    }
}
