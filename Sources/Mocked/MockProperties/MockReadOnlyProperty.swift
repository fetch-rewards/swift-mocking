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
        self._getter = OSAllocatedUnfairLock(
            uncheckedState: MockPropertyGetter(
                exposedPropertyDescription: exposedPropertyDescription
            )
        )
    }

    // MARK: Factories

    /// Creates a property and a closure for invoking the property's getter,
    /// returning them in a labeled tuple.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a property and a closure for invoking the
    ///   property's getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyProperty,
        get: () -> Value
    ) {
        let property = MockReadOnlyProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: { property.getter.get() }
        )
    }
}

// MARK: - Sendable

extension MockReadOnlyProperty: Sendable
where Value: Sendable {

    // MARK: Factories

    /// Creates a property and a closure for invoking the property's getter,
    /// returning them in a labeled tuple.
    ///
    /// - Parameter exposedPropertyDescription: The description of the mock's
    ///   exposed property.
    /// - Returns: A tuple containing a property and a closure for invoking the
    ///   property's getter.
    public static func makeProperty(
        exposedPropertyDescription: MockImplementationDescription
    ) -> (
        property: MockReadOnlyProperty,
        get: @Sendable () -> Value
    ) {
        let property = MockReadOnlyProperty(
            exposedPropertyDescription: exposedPropertyDescription
        )

        return (
            property: property,
            get: { property.getter.get() }
        )
    }
}
