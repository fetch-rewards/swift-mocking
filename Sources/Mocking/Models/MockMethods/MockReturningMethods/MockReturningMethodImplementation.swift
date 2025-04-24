//
//  MockReturningMethodImplementation.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation

/// An implementation for a returning mock method.
public protocol MockReturningMethodImplementation<
    Arguments,
    Error,
    ReturnValue,
    Closure
> {
    /// The implementation's arguments type.
    associatedtype Arguments

    /// The implementation's error type.
    associatedtype Error: Swift.Error

    /// The implementation's return value type.
    associatedtype ReturnValue

    /// The implementation's closure type.
    associatedtype Closure

    /// Triggers a fatal error when invoked if the implementation must return a
    /// value, otherwise, does nothing.
    static var unimplemented: Self { get }

    /// Invokes the provided closure when invoked.
    ///
    /// - Parameter closure: The closure to invoke.
    static func uncheckedInvokes(_ closure: Closure) -> Self

    /// The implementation as a closure, or `nil` if unimplemented.
    var _closure: Closure? { get }
}
