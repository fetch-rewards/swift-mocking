//
//  MockReturningParameterizedThrowingMethodImplementation.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation

/// An implementation for a returning, parameterized, throwing mock method.
public protocol MockReturningParameterizedThrowingMethodImplementation<
    Arguments,
    ReturnValue,
    Closure
>: MockReturningMethodImplementation where Error == any Swift.Error {}
