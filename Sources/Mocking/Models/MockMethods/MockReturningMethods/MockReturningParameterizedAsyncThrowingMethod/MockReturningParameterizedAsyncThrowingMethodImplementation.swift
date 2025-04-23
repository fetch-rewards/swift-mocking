//
//  MockReturningParameterizedAsyncThrowingMethodImplementation.swift
//  Mocking
//
//  Created by Gray Campbell on 2/25/25.
//

import Foundation

/// An implementation for a returning, parameterized, async, throwing mock
/// method.
public protocol MockReturningParameterizedAsyncThrowingMethodImplementation<
    Arguments,
    ReturnValue,
    Closure
>: MockReturningMethodImplementation where Error == any Swift.Error {}
