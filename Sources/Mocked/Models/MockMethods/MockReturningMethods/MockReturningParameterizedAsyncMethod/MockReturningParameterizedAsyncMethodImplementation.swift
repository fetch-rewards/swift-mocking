//
//  MockReturningParameterizedAsyncMethodImplementation.swift
//  Mocked
//
//  Created by Gray Campbell on 2/26/25.
//

/// An implementation for a returning, parameterized, async mock method.
public protocol MockReturningParameterizedAsyncMethodImplementation<
    Arguments,
    ReturnValue,
    Closure
>: MockReturningMethodImplementation where Error == Never {}
