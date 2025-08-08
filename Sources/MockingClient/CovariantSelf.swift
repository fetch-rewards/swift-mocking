//
//  CovariantSelf.swift
//  swift-mocking
//
//  Created by Gray Campbell on 8/8/25.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of covariant `Self`.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of covariant `Self`. For temporary testing of Mocked's
///   expansion, use the `Playground` protocol in `main.swift`.
@Mocked(compilationCondition: .none)
public protocol CovariantSelf {
    var propertyWithSelf: Self { get set }

    func methodReturningSelf() -> Self
    func methodWithSelfParameter(parameter: Self)
    func methodWithNestedSelfParameter(parameter: [Self])
}
