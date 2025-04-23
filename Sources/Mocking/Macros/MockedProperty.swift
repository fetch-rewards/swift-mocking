//
//  MockedProperty.swift
//  Mocking
//
//  Created by Gray Campbell on 1/16/25.
//

/// A macro that produces a mocked property when attached to a property
/// declaration.
///
/// - Important: This macro is used in the expansion of the ``MockedMembers()``
///   macro and is not intended to be used directly. To generate a mocked
///   property, use the ``MockableProperty(_:)`` macro in conjunction with the
///   ``MockedMembers()`` macro instead.
/// - Parameters:
///   - propertyType: The type of property being mocked.
///   - mockName: The name of the encompassing mock declaration.
///   - isMockAnActor: A Boolean value indicating whether the encompassing mock
///     is an actor.
@attached(peer, names: prefixed(_), prefixed(__))
@attached(accessor)
public macro _MockedProperty(
    _ propertyType: MockedPropertyType,
    mockName: String,
    isMockAnActor: Bool
) = #externalMacro(
    module: "MockingMacros",
    type: "MockedPropertyMacro"
)
