//
//  MockVoidAsyncThrowingMethodWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidAsyncThrowingMethodWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidAsyncThrowingMethodWithParameters<Arguments>
    typealias Arguments = (string: String, boolean: Bool)

    // MARK: Call Count Tests

    func testCallCount() async throws {
        try await self.withSUT { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            try await invoke(("a", true))
            XCTAssertEqual(sut.callCount, 1)

            sut.error = URLError(.badURL)

            do {
                try await invoke(("b", false))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }

            XCTAssertEqual(sut.callCount, 2)
        }
    }

    // MARK: Invocations Tests

    func testInvocations() async throws {
        try await self.withSUT { sut, invoke in
            XCTAssertTrue(sut.invocations.isEmpty)

            try await invoke(("a", true))
            XCTAssertEqual(sut.invocations.count, 1)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)

            try await invoke(("b", false))
            XCTAssertEqual(sut.invocations.count, 2)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)
            XCTAssertEqual(sut.invocations.last?.string, "b")
            XCTAssertEqual(sut.invocations.last?.boolean, false)
        }
    }

    // MARK: Last Invocation Tests

    func testLastInvocation() async throws {
        try await self.withSUT { sut, invoke in
            XCTAssertNil(sut.lastInvocation)

            try await invoke(("a", true))
            XCTAssertEqual(sut.lastInvocation?.string, "a")
            XCTAssertEqual(sut.lastInvocation?.boolean, true)

            try await invoke(("b", false))
            XCTAssertEqual(sut.lastInvocation?.string, "b")
            XCTAssertEqual(sut.lastInvocation?.boolean, false)
        }
    }

    // MARK: Thrown Errors Tests

    func testThrownErrors() async throws {
        try await self.withSUT { sut, invoke in
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            try await invoke(("a", true))
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            sut.error = URLError(.badURL)

            do {
                try await invoke(("b", false))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)
                XCTAssertEqual(sut.thrownErrors.count, 1)

                let firstThrownError = try XCTUnwrap(sut.thrownErrors.first as? URLError)

                XCTAssertEqual(firstThrownError.code, .badURL)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }

            sut.error = URLError(.badServerResponse)

            do {
                try await invoke(("c", true))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badServerResponse)
                XCTAssertEqual(sut.thrownErrors.count, 2)

                let firstThrownError = try XCTUnwrap(sut.thrownErrors.first as? URLError)
                let lastThrownError = try XCTUnwrap(sut.thrownErrors.last as? URLError)

                XCTAssertEqual(firstThrownError.code, .badURL)
                XCTAssertEqual(lastThrownError.code, .badServerResponse)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badServerResponse)")
            }
        }
    }

    // MARK: Last Thrown Error Tests

    func testLastThrownError() async throws {
        try await self.withSUT { sut, invoke in
            XCTAssertNil(sut.lastThrownError)

            try await invoke(("a", true))
            XCTAssertNil(sut.lastThrownError)

            sut.error = URLError(.badURL)

            do {
                try await invoke(("b", false))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)

                let lastThrownError = try XCTUnwrap(sut.lastThrownError as? URLError)

                XCTAssertEqual(lastThrownError.code, .badURL)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }

            sut.error = URLError(.badServerResponse)

            do {
                try await invoke(("c", true))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badServerResponse)

                let lastThrownError = try XCTUnwrap(sut.lastThrownError as? URLError)

                XCTAssertEqual(lastThrownError.code, .badServerResponse)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badServerResponse)")
            }
        }
    }
}

// MARK: - Helpers

extension MockVoidAsyncThrowingMethodWithParametersTests {
    private func withSUT(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) async throws -> Void
        ) async throws -> Void
    ) async rethrows {
        let (sut, invoke) = SUT.makeMethod()

        try await test(sut, invoke)
    }
}
