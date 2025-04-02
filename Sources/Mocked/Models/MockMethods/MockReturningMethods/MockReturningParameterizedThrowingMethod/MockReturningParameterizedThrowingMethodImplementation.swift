//
//  MockReturningParameterizedThrowingMethodImplementation.swift
//  Mocked
//
//  Created by Gray Campbell on 2/25/25.
//

import Foundation

/// An implementation for a returning, parameterized, throwing mock method.
public protocol MockReturningParameterizedThrowingMethodImplementation<
    Arguments,
    ReturnValue,
    Closure
>: MockReturningMethodImplementation where Error == any Swift.Error {}
