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
    case readOnly(AsyncSpecifier? = nil, ThrowsSpecifier? = nil)

    /// A read-write subscript.
    case readWrite

    // MARK: Properties

    /// A read-only subscript without any effect specifiers.
    public static var readOnly: MockedSubscriptType {
        .readOnly()
    }

    // MARK: Constructors

    /// Returns a read-only subscript with the provided `throwsSpecifier`.
    ///
    /// - Returns: A read-only subscript with the provided `throwsSpecifier`.
    public static func readOnly(
        _ throwsSpecifier: ThrowsSpecifier
    ) -> MockedSubscriptType {
        .readOnly(nil, throwsSpecifier)
    }
}
