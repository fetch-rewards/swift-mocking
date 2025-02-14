//
//  MockedMethod.swift
//  Mocked
//
//  Created by Gray Campbell on 1/14/25.
//

/// A macro that produces a mocked method when attached to a method declaration.
///
/// - Important: This macro is used in the expansion of the ``MockedMembers()``
///   macro and is not intended to be used directly. To generate a mocked
///   method, use the ``MockableMethod(mockMethodName:)`` macro (optional) in
///   conjunction with the ``MockedMembers()`` macro instead.
/// - Parameters:
///   - mockName: The name of the encompassing mock declaration.
///   - isMockAnActor: A Boolean value indicating whether the encompassing mock
///     is an actor.
///   - mockMethodName: The name to use for the mock method.
@attached(peer, names: arbitrary)
@attached(body)
public macro _MockedMethod(
    mockName: String,
    isMockAnActor: Bool,
    mockMethodName: String
) = #externalMacro(
    module: "MockedMacros",
    type: "MockedMethodMacro"
)
