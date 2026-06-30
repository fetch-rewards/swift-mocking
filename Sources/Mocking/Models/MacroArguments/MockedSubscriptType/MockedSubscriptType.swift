//
//  MockedSubscriptType.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation

/// The type of subscript being mocked.
public enum MockedSubscriptType {

    // MARK: Cases

    /// A read-only subscript.
    ///
    /// - Parameters:
    ///   - asyncSpecifier: The getter's `async` specifier.
    ///   - throwsSpecifier: The getter's `throws` specifier.
    case readOnly(AsyncSpecifier?, ThrowsSpecifier?)

    /// A read-write subscript.
    case readWrite

    // MARK: Properties

    /// A read-only subscript without any effect specifiers.
    public static var readOnly: MockedSubscriptType {
        .readOnly(nil, nil)
    }

    // MARK: Constructors

    /// Returns a read-only subscript with the provided `asyncSpecifier`.
    ///
    /// - Returns: A read-only subscript with the provided `asyncSpecifier`.
    public static func readOnly(
        _ asyncSpecifier: AsyncSpecifier
    ) -> MockedSubscriptType {
        .readOnly(asyncSpecifier, nil)
    }

    /// Returns a read-only subscript with the provided `throwsSpecifier`.
    ///
    /// - Returns: A read-only subscript with the provided `throwsSpecifier`.
    public static func readOnly(
        _ throwsSpecifier: ThrowsSpecifier
    ) -> MockedSubscriptType {
        .readOnly(nil, throwsSpecifier)
    }
}
