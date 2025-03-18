//
//  MockVoidParameterizedThrowingMethodImplementation.swift
//  Mocked
//
//  Created by Gray Campbell on 2/24/25.
//

/// An implementation for a void, parameterized, throwing mock method.
public protocol MockVoidParameterizedThrowingMethodImplementation<
    Arguments,
    Closure
>: MockVoidMethodImplementation where Error == any Swift.Error {}
