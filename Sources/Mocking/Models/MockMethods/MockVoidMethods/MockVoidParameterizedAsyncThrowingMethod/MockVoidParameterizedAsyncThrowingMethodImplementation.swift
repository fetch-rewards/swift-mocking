//
//  MockVoidParameterizedAsyncThrowingMethodImplementation.swift
//
//  Copyright © 2026 Fetch.
//

/// An implementation for a void, parameterized, async, throwing mock method.
public protocol MockVoidParameterizedAsyncThrowingMethodImplementation<
    Arguments,
    Closure
>: MockVoidMethodImplementation where Error == any Swift.Error {}
