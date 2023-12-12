//
//  MockVoidAsyncThrowingMethodWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidAsyncThrowingMethodWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidAsyncThrowingMethodWithoutParameters

    // MARK: Call Count Tests

    func testCallCount() async throws {
        try await self.withSUT { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            try await invoke()
            XCTAssertEqual(sut.callCount, 1)

            sut.error = URLError(.badURL)

            do {
                try await invoke()
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }

            XCTAssertEqual(sut.callCount, 2)
        }
    }

    // MARK: Thrown Errors Tests

    func testThrownErrors() async throws {
        try await self.withSUT { sut, invoke in
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            try await invoke()
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            sut.error = URLError(.badURL)

            do {
                try await invoke()
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
                try await invoke()
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

            try await invoke()
            XCTAssertNil(sut.lastThrownError)

            sut.error = URLError(.badURL)

            do {
                try await invoke()
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
                try await invoke()
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

extension MockVoidAsyncThrowingMethodWithoutParametersTests {
    private func withSUT(
        test: (
            _ sut: SUT,
            _ invoke: () async throws -> Void
        ) async throws -> Void
    ) async rethrows {
        let (sut, invoke) = SUT.makeMethod()

        try await test(sut, invoke)
    }
}
