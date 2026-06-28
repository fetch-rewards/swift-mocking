//
//  MockedSubscriptType+AsyncSpecifier.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation

extension MockedSubscriptType {

    /// The `async` specifier to apply to a mocked subscript's accessor.
    public enum AsyncSpecifier: String, CaseIterable {

        // MARK: Cases

        /// An `async` specifier.
        case async
    }
}
