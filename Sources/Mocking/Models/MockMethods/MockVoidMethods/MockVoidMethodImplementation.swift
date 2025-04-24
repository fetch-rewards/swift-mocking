//
//  MockVoidMethodImplementation.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation

/// An implementation for a void mock method.
public protocol MockVoidMethodImplementation<
    Arguments,
    Error,
    Closure
>: MockReturningMethodImplementation where ReturnValue == Void {}
