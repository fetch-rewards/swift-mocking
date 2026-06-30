//
//  SendableSubscripts.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of Sendable subscripts.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of Sendable subscripts. For temporary testing of
///   Mocked's expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol SendableSubscripts: Sendable {
    subscript(key: String) -> String? { get }
    subscript(key: String, default defaultValue: String) -> String { get set }
    subscript(index: Int) -> String { get set }
}
