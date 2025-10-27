//
//  GenericMethodsWithInlineArrayTypes.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of generic methods that leverage
/// inline array syntax and value-generic arguments.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of inline array syntax. For temporary testing of Mocked's
///   expansion, use the `Playground` protocol in `main.swift`.
@available(macOS 26.0, *)
@Mocked
public protocol GenericMethodsWithInlineArrayTypes {
    func genericMethodWithInlineArrayParameter<Element>(
        parameter: [3 of Element]
    ) -> [3 of Element]

    func genericMethodReturningInlineArray<Element>(
        parameter: InlineArray<3, Element>
    ) -> InlineArray<3, Element>

    func genericMethodWithInlineArraySameTypeRequirement<Element>(
        parameter: InlineArray<3, Element>
    ) -> Element where Element: Sendable, InlineArray<3, Element> == InlineArray<3, Element>
}
