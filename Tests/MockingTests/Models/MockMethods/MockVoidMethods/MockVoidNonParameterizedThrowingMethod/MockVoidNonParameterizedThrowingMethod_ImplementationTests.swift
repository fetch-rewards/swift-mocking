//
//  MockVoidNonParameterizedThrowingMethod_ImplementationTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockVoidNonParameterizedThrowingMethod_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockVoidNonParameterizedThrowingMethod

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async throws {
        try await confirmation(expectedCount: .zero) { _ in
            let sut: SUT = .unimplemented

            try sut()
        }
    }

    @Test
    func uncheckedInvokes() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .uncheckedInvokes {
                confirmation.confirm()
            }

            try sut()
        }
    }

    @Test
    func invokes() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .invokes {
                confirmation.confirm()
            }

            try sut()
        }
    }

    @Test
    func `throws`() throws {
        let sut: SUT = .throws(URLError(.badURL))

        #expect(throws: URLError(.badURL)) {
            _ = try sut()
        }
    }
}
