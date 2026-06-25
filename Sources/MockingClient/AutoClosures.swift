//
//  AutoClosures.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of autoclosures.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of autoclosures. For temporary testing of Mocked's
///   expansion, use the `Playground` protocol in `main.swift`.
@Mocked(compilationCondition: .none)
public protocol AutoClosures {
//    func methodWithVoidAutoClosure(autoClosure: @escaping @autoclosure () -> Void)
    func methodWithNonVoidAutoClosure(autoClosure: @escaping @autoclosure () async -> Int) async
//    func methodWithConsumingVoidAutoClosure(autoClosure: consuming @escaping @autoclosure () -> Void)
//    func methodWithConsumingNonVoidAutoClosure(autoClosure: consuming @escaping @autoclosure () -> Int)
}
