//
//  MockedPropertyType+AsyncSpecifier.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation

extension MockedPropertyType {

    /// The `async` specifier to apply to a mocked property's accessor.
    public enum AsyncSpecifier: String, CaseIterable {

        // MARK: Cases

        /// An `async` specifier.
        case async
    }
}
