//
//  MockReadWriteProperty.swift
//  Mocked
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Locked

/// The implementation details and invocation records for a mock's read-write
/// property.
public final class MockReadWriteProperty<Value> {

    // MARK: Properties

    /// The property's getter.
    @Locked(.unchecked)
    public var getter: MockPropertyGetter<Value>

    /// The property's setter.
    @Locked(.unchecked)
    public var setter = MockPropertySetter<Value>()

    // MARK: Initializers

    /// Creates a read-write property.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    private init(exposedPropertyDescription: MockImplementationDescription) {
        self._getter = OSAllocatedUnfairLock(
            uncheckedState: MockPropertyGetter(
                exposedPropertyDescription: exposedPropertyDescription
            )
        )
    }

    // MARK: Factories

    /// Creates a property, a closure for invoking the property's getter, and a
    /// closure for invoking the property's setter, returning them in a labeled
    /// tuple.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a property, a closure for invoking the
    ///   property's getter, and a closure for invoking the property's setter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadWriteProperty,
        get: () -> Value,
        set: (Value) -> Void
    ) {
        let property = MockReadWriteProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: { property.getter.get() },
            set: { property.setter.set($0) }
        )
    }
}

// MARK: - Sendable

extension MockReadWriteProperty: Sendable
where Value: Sendable {

    // MARK: Factories

    /// Creates a property, a closure for invoking the property's getter, and a
    /// closure for invoking the property's setter, returning them in a labeled
    /// tuple.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a property, a closure for invoking the
    ///   property's getter, and a closure for invoking the property's setter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadWriteProperty,
        get: @Sendable () -> Value,
        set: @Sendable (Value) -> Void
    ) {
        let property = MockReadWriteProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: { property.getter.get() },
            set: { property.setter.set($0) }
        )
    }
}
