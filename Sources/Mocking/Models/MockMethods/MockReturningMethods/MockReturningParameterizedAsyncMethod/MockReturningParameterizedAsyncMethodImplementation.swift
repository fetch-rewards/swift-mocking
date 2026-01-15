//
//  MockReturningParameterizedAsyncMethodImplementation.swift
//
//  Copyright © 2026 Fetch.
//

/// An implementation for a returning, parameterized, async mock method.
public protocol MockReturningParameterizedAsyncMethodImplementation<
    Arguments,
    ReturnValue,
    Closure
>: MockReturningMethodImplementation where Error == Never {}
