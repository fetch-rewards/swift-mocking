//
//  MockableProperty.swift
//  Mocked
//
//  Created by Gray Campbell on 1/19/25.
//

/// A macro that marks a property as being mockable.
///
/// This macro should only be used in conjunction with the `@MockedMembers`
/// macro.
/// ```swift
/// @MockedMembers
/// final class DependencyMock: Dependency {
///     @MockableProperty(.readWrite)
///     var count: Int
/// }
/// ```
@attached(accessor)
public macro MockableProperty(_ propertyType: MockedPropertyType) = #externalMacro(
    module: "MockedMacros",
    type: "MockablePropertyMacro"
)
