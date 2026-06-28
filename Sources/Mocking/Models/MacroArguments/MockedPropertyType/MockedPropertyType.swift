//
//  MockedPropertyType.swift
//
//  Copyright © 2026 Fetch.
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
    case readOnly(AsyncSpecifier?, ThrowsSpecifier?)

    /// A read-write property.
    case readWrite

    // MARK: Properties

    /// A read-only property without any effect specifiers.
    public static var readOnly: MockedPropertyType {
        .readOnly(nil, nil)
    }

    // MARK: Constructors

    /// Returns a read-only property with the provided `asyncSpecifier`.
    ///
    /// - Returns: A read-only property with the provided `asyncSpecifier`.
    public static func readOnly(
        _ asyncSpecifier: AsyncSpecifier
    ) -> MockedPropertyType {
        .readOnly(asyncSpecifier, nil)
    }

    /// Returns a read-only property with the provided `throwsSpecifier`.
    ///
    /// - Returns: A read-only property with the provided `throwsSpecifier`.
    public static func readOnly(
        _ throwsSpecifier: ThrowsSpecifier
    ) -> MockedPropertyType {
        .readOnly(nil, throwsSpecifier)
    }
}
