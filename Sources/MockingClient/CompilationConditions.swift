//
//  CompilationConditions.swift
//  MockingClient
//
//  Created by Gray Campbell on 3/30/25.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of its `compilationCondition`
/// argument without a provided value.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of its `compilationCondition` argument without a
///   provided value. For temporary testing of Mocked's expansion, use the
///   `Playground` protocol in `main.swift`.
@Mocked
public protocol DefaultCompilationCondition {}

/// A protocol for verifying Mocked's handling of its `compilationCondition`
/// argument with a `.none` value.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of its `compilationCondition` argument with a `.none`
///   value. For temporary testing of Mocked's expansion, use the `Playground`
///   protocol in `main.swift`.
@Mocked(compilationCondition: .none)
public protocol NoneCompilationCondition {}

/// A protocol for verifying Mocked's handling of its `compilationCondition`
/// argument with a `.debug` value.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of its `compilationCondition` argument with a `.debug`
///   value. For temporary testing of Mocked's expansion, use the `Playground`
///   protocol in `main.swift`.
@Mocked(compilationCondition: .debug)
public protocol DebugCompilationCondition {}

/// A protocol for verifying Mocked's handling of its `compilationCondition`
/// argument with a `.swiftMockingEnabled` value.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of its `compilationCondition` argument with a
///   `.swiftMockingEnabled` value. For temporary testing of Mocked's expansion,
///   use the `Playground` protocol in `main.swift`.
@Mocked(compilationCondition: .swiftMockingEnabled)
public protocol SwiftMockingEnabledCompilationCondition {}

/// A protocol for verifying Mocked's handling of its `compilationCondition`
/// argument with a `.custom` compilation condition.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of its `compilationCondition` argument with a `.custom`
///   compilation condition. For temporary testing of Mocked's expansion, use
///   the `Playground` protocol in `main.swift`.
@Mocked(compilationCondition: .custom("!RELEASE"))
public protocol CustomCompilationCondition {}

/// A protocol for verifying Mocked's handling of its `compilationCondition`
/// argument with a string literal compilation condition.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of its `compilationCondition` argument with a string
///   literal compilation condition. For temporary testing of Mocked's
///   expansion, use the `Playground` protocol in `main.swift`.
@Mocked(compilationCondition: "!RELEASE")
public protocol StringLiteralCompilationCondition {}
