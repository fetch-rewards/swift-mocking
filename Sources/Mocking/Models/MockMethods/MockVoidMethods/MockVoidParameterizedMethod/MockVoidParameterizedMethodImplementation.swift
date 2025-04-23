//
//  MockVoidParameterizedMethodImplementation.swift
//  Mocking
//
//  Created by Gray Campbell on 2/24/25.
//

import Foundation

/// An implementation for a void, parameterized mock method.
public protocol MockVoidParameterizedMethodImplementation<
    Arguments,
    Closure
>: MockVoidMethodImplementation where Error == Never {}
