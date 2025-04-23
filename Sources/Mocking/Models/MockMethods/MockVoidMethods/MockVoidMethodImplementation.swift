//
//  MockVoidMethodImplementation.swift
//  Mocking
//
//  Created by Gray Campbell on 2/17/25.
//

import Foundation

/// An implementation for a void mock method.
public protocol MockVoidMethodImplementation<
    Arguments,
    Error,
    Closure
>: MockReturningMethodImplementation where ReturnValue == Void {}
