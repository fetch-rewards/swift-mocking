//
//  MockedMembers.swift
//  Mocked
//
//  Created by Gray Campbell on 1/15/25.
//

/// A macro that adds the ``MockedProperty(_:mockName:isMockAnActor:)`` to all
/// property declarations that are marked with ``MockableProperty(_:)`` and the
/// ``MockedMethod(mockName:isMockAnActor:)`` macro to all method declarations
/// inside the declaration to which it's attached.
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
///         isMockAnActor: false
///     )
///     public func method()
/// }
/// ```
@attached(memberAttribute)
@attached(member, names: named(resetMockedStaticMembers))
public macro MockedMembers() = #externalMacro(
    module: "MockedMacros",
    type: "MockedMembersMacro"
)
