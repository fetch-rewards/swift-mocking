//
//  MockVoidParameterizedAsyncThrowingMethodImplementation.swift
//  Mocking
//
//  Created by Gray Campbell on 2/24/25.
//

/// An implementation for a void, parameterized, async, throwing mock method.
public protocol MockVoidParameterizedAsyncThrowingMethodImplementation<
    Arguments,
    Closure
>: MockVoidMethodImplementation where Error == any Swift.Error {}
