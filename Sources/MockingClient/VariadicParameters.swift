//
//  VariadicParameters.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of variadic parameters.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of variadic parameters. For temporary testing of
///   Mocked's expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol VariadicParameters {
    func method(strings: String..., integers: Int...)
}
