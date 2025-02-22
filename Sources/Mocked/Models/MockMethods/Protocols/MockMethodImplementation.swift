//
//  MockMethodImplementation.swift
//  Mocked
//
//  Created by Gray Campbell on 2/18/25.
//

import Foundation

/// An implementation for a mock method.
public protocol MockMethodImplementation<
    Arguments,
    Error,
    Closure
>: Sendable {

    /// The implementation's arguments type.
    associatedtype Arguments

    /// The implementation's error type.
    associatedtype Error: Swift.Error

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

// MARK: - Sendable

extension MockMethodImplementation where Closure: Sendable {

    /// Invokes the provided closure when invoked.
    ///
    /// - Parameter closure: The closure to invoke.
    public static func invokes(_ closure: Closure) -> Self {
        .uncheckedInvokes(closure)
    }
}
