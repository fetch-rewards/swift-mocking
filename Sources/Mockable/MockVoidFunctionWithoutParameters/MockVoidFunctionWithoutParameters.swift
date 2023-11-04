//
//  MockVoidFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation

/// The invocation records and implementation for a mock's void function that
/// does not have parameters.
public struct MockVoidFunctionWithoutParameters {

    // MARK: Properties

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    // MARK: Initializers

    /// Creates a void function without parameters.
    public init() {}

    // MARK: Invoke

    /// Records the invocation of the function.
    ///
    /// - Important: This method should only be called from a mock's
    ///   function conformance declaration. Unless you are writing an
    ///   implementation for a mock, you should never call this method
    ///   directly.
    public mutating func invoke() {
        self.callCount += 1
    }
}
