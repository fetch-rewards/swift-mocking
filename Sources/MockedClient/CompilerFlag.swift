//
//  CompilerFlag.swift
//  MockedClient
//
//  Created by Gray Campbell on 3/30/25.
//

import Foundation
public import Mocked

/// A protocol for verifying Mocked's handling of its `compilerFlag` argument.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of its `compilerFlag` argument. For temporary testing of
///   Mocked's expansion, use the `Playground` protocol in `main.swift`.
@Mocked(compilerFlag: "DEBUG")
public protocol CompilerFlag {}
