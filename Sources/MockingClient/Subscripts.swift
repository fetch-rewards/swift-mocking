//
//  Subscripts.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of subscripts.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of subscripts. For temporary testing of Mocked's
///   expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol Subscripts {
    subscript(key: String) -> String? { get }
    subscript(key: String, default defaultValue: String) -> String { get set }
    subscript(index: Int) -> String { get set }
    subscript(asyncKey key: String) -> String? { get async }
    subscript(throwingKey key: String) -> String? { get throws }
    subscript(asyncThrowingKey key: String) -> String? { get async throws }
}
