//
//  MockVoidParameterizedAsyncMethodImplementation.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation

/// An implementation for a void, parameterized, async mock method.
public protocol MockVoidParameterizedAsyncMethodImplementation<
    Arguments,
    Closure
>: MockVoidMethodImplementation where Error == Never {}
