//
//  MockVoidNonParameterizedAsyncThrowingMethod_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 3/18/25.
//

import Foundation
import Testing
@testable import Mocked

struct MockVoidNonParameterizedAsyncThrowingMethod_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockVoidNonParameterizedAsyncThrowingMethod

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async throws {
        try await confirmation(expectedCount: .zero) { confirmation in
            let sut: SUT = .unimplemented

            try await sut()
        }
    }

    @Test
    func uncheckedInvokes() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .uncheckedInvokes {
                confirmation.confirm()
            }

            try await sut()
        }
    }

    @Test
    func invokes() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .invokes {
                confirmation.confirm()
            }

            try await sut()
        }
    }

    @Test
    func `throws`() async throws {
        let sut: SUT = .throws(URLError(.badURL))

        await #expect(throws: URLError(.badURL)) {
            _ = try await sut()
        }
    }
}
