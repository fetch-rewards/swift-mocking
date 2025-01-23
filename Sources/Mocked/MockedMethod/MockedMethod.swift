//
//  MockedMethod.swift
//  Mocked
//
//  Created by Gray Campbell on 1/14/25.
//

/// A macro that produces a mocked method when attached to a method declaration.
@attached(peer, names: arbitrary)
@attached(body)
public macro MockedMethod(
    mockName: String,
    isMockAnActor: Bool,
    mockMethodName: String? = nil
) = #externalMacro(
    module: "MockedMacros",
    type: "MockedMethodMacro"
)
