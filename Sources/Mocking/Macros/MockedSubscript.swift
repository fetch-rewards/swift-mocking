//
//  MockedSubscript.swift
//
//  Copyright © 2026 Fetch.
//

/// A macro that produces a mocked subscript when attached to a subscript
/// declaration.
///
/// - Important: This macro is used in the expansion of the ``MockedMembers()``
///   macro and is not intended to be used directly. To generate a mocked
///   subscript, use the ``MockableSubscript(_:)`` macro in conjunction with the
///   ``MockedMembers()`` macro instead.
/// - Parameters:
///   - subscriptType: The type of subscript being mocked.
///   - mockName: The name of the encompassing mock declaration.
///   - isMockAnActor: A Boolean value indicating whether the encompassing mock
///     is an actor.
///   - mockSubscriptName: The disambiguated name to use for the mock's
///     subscript backing and exposed properties.
@attached(peer, names: prefixed(_), prefixed(__))
@attached(accessor)
public macro _MockedSubscript(
    _ subscriptType: MockedSubscriptType,
    mockName: String,
    isMockAnActor: Bool,
    mockSubscriptName: String
) = #externalMacro(
    module: "MockingMacros",
    type: "MockedSubscriptMacro"
)
