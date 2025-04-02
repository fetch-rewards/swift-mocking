//
//  MockVoidParameterizedAsyncMethodImplementation.swift
//  Mocked
//
//  Created by Gray Campbell on 2/24/25.
//

import Foundation

/// An implementation for a void, parameterized, async mock method.
public protocol MockVoidParameterizedAsyncMethodImplementation<
    Arguments,
    Closure
>: MockVoidMethodImplementation where Error == Never {}
