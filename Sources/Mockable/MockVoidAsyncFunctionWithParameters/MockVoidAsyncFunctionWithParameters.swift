//
//  MockVoidAsyncFunctionWithParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's void, async function
/// that has parameters.
public struct MockVoidAsyncFunctionWithParameters<Arguments> {

    // MARK: Properties

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The latest arguments with which the function has been invoked.
    public var latestInvocation: Arguments? {
        self.invocations.last
    }

    // MARK: Initializers

    /// Creates a void, async function with parameters.
    public init() {}

    // MARK: Invoke

    /// Records the invocation of the function.
    ///
    /// - Important: This method should only be called from a mock's
    ///   function conformance declaration. Unless you are writing an
    ///   implementation for a mock, you should never call this method
    ///   directly.
    /// - Parameter arguments: The arguments with which the function is being
    ///   invoked.
    public mutating func invoke(_ arguments: Arguments) async {
        self.callCount += 1
        self.invocations.append(arguments)
    }
}
