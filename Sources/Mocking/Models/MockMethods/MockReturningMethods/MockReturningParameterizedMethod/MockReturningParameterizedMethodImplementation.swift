//
//  MockReturningParameterizedMethodImplementation.swift
//  Mocking
//
//  Created by Gray Campbell on 2/25/25.
//

import Foundation

/// An implementation for a returning, parameterized mock method.
public protocol MockReturningParameterizedMethodImplementation<
    Arguments,
    ReturnValue,
    Closure
>: MockReturningMethodImplementation where Error == Never {}
