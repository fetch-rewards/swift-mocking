//
//  Initializers.swift
//  MockingClient
//
//  Created by Gray Campbell on 3/29/25.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of initializers.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of initializers. For temporary testing of Mocked's
///   expansion, use the `Playground` protocol in `main.swift`.
@Mocked
public protocol Initializers {
    init()
    init(parameter: Int)
    init(parameters: Int...)
    init(parameter1: Int, parameter2: Int)
}
