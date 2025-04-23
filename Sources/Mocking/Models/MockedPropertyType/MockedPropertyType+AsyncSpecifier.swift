//
//  MockedPropertyType+AsyncSpecifier.swift
//  Mocking
//
//  Created by Gray Campbell on 1/21/25.
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
