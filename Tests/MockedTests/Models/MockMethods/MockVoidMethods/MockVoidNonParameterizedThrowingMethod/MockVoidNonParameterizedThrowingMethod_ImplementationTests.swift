//
//  MockVoidNonParameterizedThrowingMethod_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 3/18/25.
//

import Foundation
import Testing
@testable import Mocked

struct MockVoidNonParameterizedThrowingMethod_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockVoidNonParameterizedThrowingMethod

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async throws {
        try await confirmation(expectedCount: .zero) { confirmation in
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
