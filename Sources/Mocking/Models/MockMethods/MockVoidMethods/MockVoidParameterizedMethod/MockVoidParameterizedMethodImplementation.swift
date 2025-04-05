//
//  MockVoidParameterizedMethodImplementation.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation

/// An implementation for a void, parameterized mock method.
public protocol MockVoidParameterizedMethodImplementation<
    Arguments,
    Closure
>: MockVoidMethodImplementation where Error == Never {}
