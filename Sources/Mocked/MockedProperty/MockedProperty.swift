//
//  MockedProperty.swift
//  Mocked
//
//  Created by Gray Campbell on 1/16/25.
//

/// A macro that produces a mocked property when attached to a property
/// declaration.
@attached(peer, names: prefixed(_), prefixed(__))
@attached(accessor)
public macro MockedProperty(
    _ propertyType: MockedPropertyType,
    mockName: String,
    isMockAnActor: Bool
) = #externalMacro(
    module: "MockedMacros",
    type: "MockedPropertyMacro"
)
