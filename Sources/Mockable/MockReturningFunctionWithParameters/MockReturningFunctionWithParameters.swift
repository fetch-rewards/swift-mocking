//
//  MockReturningFunctionWithParameters.swift
//  Mockable
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import XCTestDynamicOverlay

/// The invocation records and implementation for a mock's returning function
/// that has parameters.
public struct MockReturningFunctionWithParameters<Arguments, ReturnValue> {

    // MARK: Properties
    
    /// The function's return value.
    public var returnValue: ReturnValue?

    /// The number of times the function has been called.
    public private(set) var callCount: Int = .zero

    /// All the arguments with which the function has been invoked.
    public private(set) var invocations: [Arguments] = []

    /// The latest arguments with which the function has been invoked.
    public private(set) var latestInvocation: Arguments?

    /// All the values that have been returned by the function.
    public private(set) var returnValues: [ReturnValue] = []

    /// The latest value returned by the function.
    public private(set) var latestReturnValue: ReturnValue?

    // MARK: Initializers
    
    /// Creates a returning function with parameters.
    public init() {}

    // MARK: Invoke

    /// Records the invocation of the function and returns the function's return
    /// value.
    ///
    /// - Important: This method should only be called from a mock's
    ///   function conformance declaration. Unless you are writing an
    ///   implementation for a mock, you should never call this method
    ///   directly.
    /// - Parameter arguments: The arguments with which the function is being
    ///   invoked.
    /// - Returns: The function's return value.
    public mutating func invoke(_ arguments: Arguments) -> ReturnValue {
        guard let returnValue = self.returnValue else {
            return unimplemented("\(Self.self).returnValue")
        }
        
        self.callCount += 1
        self.invocations.append(arguments)
        self.latestInvocation = arguments
        self.returnValues.append(returnValue)
        self.latestReturnValue = returnValue

        return returnValue
    }
}
