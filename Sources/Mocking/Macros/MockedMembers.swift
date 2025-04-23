//
//  MockedMembers.swift
//  Mocking
//
//  Created by Gray Campbell on 1/15/25.
//

/// A macro that adds the `@_MockedProperty` macro to all property declarations
/// that are marked with ``MockableProperty(_:)`` and the `@_MockedMethod` macro
/// to all method declarations inside the declaration to which it's attached.
///
/// For example:
/// ```swift
/// @MockedMembers
/// public final class DependencyMock: Dependency {
///     @MockableProperty(.readWrite)
///     public var property: String
///
///     public func method()
/// }
/// ```
/// expands to:
/// ```swift
/// public final class DependencyMock: Dependency {
///     public init() {}
///
///     @MockableProperty(.readWrite)
///     @MockedProperty(
///         .readWrite,
///         mockName: "DependencyMock",
///         isMockAnActor: false
///     )
///     public var property: String
///
///     @MockedMethod(
///         mockName: "DependencyMock",
///         isMockAnActor: false,
///         mockMethodName: "method"
///     )
///     public func method()
/// }
/// ```
@attached(memberAttribute)
@attached(member, names: named(init), named(resetMockedStaticMembers))
public macro MockedMembers() = #externalMacro(
    module: "MockingMacros",
    type: "MockedMembersMacro"
)
