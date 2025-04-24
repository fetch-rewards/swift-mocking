//
//  MockReturningParameterizedMethodImplementation.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation

/// An implementation for a returning, parameterized mock method.
public protocol MockReturningParameterizedMethodImplementation<
    Arguments,
    ReturnValue,
    Closure
>: MockReturningMethodImplementation where Error == Never {}
