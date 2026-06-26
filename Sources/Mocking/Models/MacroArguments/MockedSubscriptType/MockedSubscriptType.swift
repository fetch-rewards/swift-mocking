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
    case readOnly

    /// A read-write subscript.
    case readWrite
}
