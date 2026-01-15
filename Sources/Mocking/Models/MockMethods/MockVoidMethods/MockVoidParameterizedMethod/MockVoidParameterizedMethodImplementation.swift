//
//  MockVoidParameterizedMethodImplementation.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation

/// An implementation for a void, parameterized mock method.
public protocol MockVoidParameterizedMethodImplementation<
    Arguments,
    Closure
>: MockVoidMethodImplementation where Error == Never {}
