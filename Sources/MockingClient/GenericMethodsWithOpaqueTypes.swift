//
//  GenericMethodsWithOpaqueTypes.swift
//  MockingClient
//
//  Created by Gray Campbell on 1/12/25.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of generic methods with opaque
/// types.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of generic methods with opaque types. For temporary
///   testing of Mocked's expansion, use the `Playground` protocol in
///   `main.swift`.
@Mocked
public protocol GenericMethodsWithOpaqueTypes {
    func genericMethodWithOpaqueTypeWithOneConstraint(parameter: some Equatable)

    func genericMethodWithOpaqueTypeWithMultipleConstraints(
        parameter: some Equatable & Sendable & Comparable
    )
}
