//
//  MockReturningFunctionWithoutParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import XCTestDynamicOverlay

/// The invocation records and implementation for a mock's returning function
/// that does not have parameters.
public struct MockReturningFunctionWithoutParameters<ReturnValue> {

    // MARK: Properties

    /// The function's return value.
    public var returnValue: ReturnValue?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [ReturnValue] = []

    /// The latest value returned by the function.
    public var latestReturnValue: ReturnValue? {
        self.returnValues.last
    }

    // MARK: Initializers

    /// Creates a returning function without parameters.
    public init() {}

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value.
    ///
    /// - Important: This method should only be called from a mock's
    ///   function conformance declaration. Unless you are writing an
    ///   implementation for a mock, you should never call this method
    ///   directly.
    /// - Returns: The function's return value.
    public mutating func invoke() -> ReturnValue {
        guard let returnValue = self.returnValue else {
            return unimplemented("\(Self.self).returnValue")
        }

        self.callCount += 1
        self.returnValues.append(returnValue)

        return returnValue
    }
}
