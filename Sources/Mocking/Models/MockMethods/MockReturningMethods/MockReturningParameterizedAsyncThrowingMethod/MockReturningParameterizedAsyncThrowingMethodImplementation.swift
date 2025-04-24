//
//  MockReturningParameterizedAsyncThrowingMethodImplementation.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation

/// An implementation for a returning, parameterized, async, throwing mock
/// method.
public protocol MockReturningParameterizedAsyncThrowingMethodImplementation<
    Arguments,
    ReturnValue,
    Closure
>: MockReturningMethodImplementation where Error == any Swift.Error {}
