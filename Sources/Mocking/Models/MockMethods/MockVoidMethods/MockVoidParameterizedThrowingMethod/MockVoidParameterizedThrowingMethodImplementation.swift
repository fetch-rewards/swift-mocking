//
//  MockVoidParameterizedThrowingMethodImplementation.swift
//
//  Copyright © 2025 Fetch.
//

/// An implementation for a void, parameterized, throwing mock method.
public protocol MockVoidParameterizedThrowingMethodImplementation<
    Arguments,
    Closure
>: MockVoidMethodImplementation where Error == any Swift.Error {}
