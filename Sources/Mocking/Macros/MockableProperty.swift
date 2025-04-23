//
//  MockableProperty.swift
//  Mocking
//
//  Created by Gray Campbell on 1/19/25.
//

/// A macro that marks a property as being mockable.
///
/// This macro does not itself produce an expansion and is intended to be used
/// in conjunction with the `@MockedMembers` macro:
/// ```swift
/// @MockedMembers
/// final class DependencyMock: Dependency {
///     @MockableProperty(.readWrite)
///     var count: Int
/// }
/// ```
///
/// - Parameter propertyType: The type of property being mocked.
@attached(accessor)
public macro MockableProperty(_ propertyType: MockedPropertyType) = #externalMacro(
    module: "MockingMacros",
    type: "MockablePropertyMacro"
)
