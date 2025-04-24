//
//  MockedPropertyType.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation

/// The type of property being mocked.
public enum MockedPropertyType {

    // MARK: Cases

    /// A read-only property.
    ///
    /// - Parameters:
    ///   - asyncSpecifier: The getter's `async` specifier.
    ///   - throwsSpecifier: The getter's `throws` specifier.
    case readOnly(AsyncSpecifier? = nil, ThrowsSpecifier? = nil)

    /// A read-write property.
    case readWrite

    // MARK: Properties

    /// A read-only property without any effect specifiers.
    public static var readOnly: MockedPropertyType {
        .readOnly()
    }

    // MARK: Constructors

    /// Returns a read-only property with the provided `throwsSpecifier`.
    ///
    /// - Returns: A read-only property with the provided `throwsSpecifier`.
    public static func readOnly(
        _ throwsSpecifier: ThrowsSpecifier
    ) -> MockedPropertyType {
        .readOnly(nil, throwsSpecifier)
    }
}
