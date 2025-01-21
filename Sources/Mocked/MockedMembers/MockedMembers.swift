//
//  MockedMembers.swift
//  Mocked
//
//  Created by Gray Campbell on 1/15/25.
//

/// A macro that adds the ``MockedMethod(mockName:isMockAnActor:)`` macro to all
/// method declarations inside the declaration to which it's attached.
///
/// For example:
/// ```swift
/// @MockedMembers
/// public final class DependencyMock: Dependency {
///     public func method()
/// }
/// ```
/// expands to:
/// ```swift
/// public final class DependencyMock: Dependency {
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
