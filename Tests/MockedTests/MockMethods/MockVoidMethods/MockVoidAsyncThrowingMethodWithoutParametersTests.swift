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
        try await self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            _ = try await invoke()
            XCTAssertEqual(sut.callCount, 1)

            sut.error = URLError(.badURL)

            do {
                _ = try await invoke()
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }

            XCTAssertEqual(sut.callCount, 2)
        }
    }

    // MARK: Errors Tests

    func testErrors() async throws {
        try await self.test { sut, invoke in
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            _ = try await invoke()
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            sut.error = URLError(.badURL)

            do {
                _ = try await invoke()
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)
                XCTAssertEqual(sut.thrownErrors.count, 1)

                let firstError = try XCTUnwrap(sut.thrownErrors.first as? URLError)

                XCTAssertEqual(firstError.code, .badURL)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }

            sut.error = URLError(.badServerResponse)

            do {
                _ = try await invoke()
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badServerResponse)
                XCTAssertEqual(sut.thrownErrors.count, 2)

                let firstError = try XCTUnwrap(sut.thrownErrors.first as? URLError)
                let lastError = try XCTUnwrap(sut.thrownErrors.last as? URLError)

                XCTAssertEqual(firstError.code, .badURL)
                XCTAssertEqual(lastError.code, .badServerResponse)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badServerResponse)")
            }
        }
    }

    // MARK: Last Error Tests

    func testLastError() async throws {
        try await self.test { sut, invoke in
            XCTAssertNil(sut.lastThrownError)

            _ = try await invoke()
            XCTAssertNil(sut.lastThrownError)

            sut.error = URLError(.badURL)

            do {
                _ = try await invoke()
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)

                let lastError = try XCTUnwrap(sut.lastThrownError as? URLError)

                XCTAssertEqual(lastError.code, .badURL)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }

            sut.error = URLError(.badServerResponse)

            do {
                _ = try await invoke()
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badServerResponse)

                let lastError = try XCTUnwrap(sut.lastThrownError as? URLError)

                XCTAssertEqual(lastError.code, .badServerResponse)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badServerResponse)")
            }
        }
    }
}

// MARK: - Helpers

extension MockVoidAsyncThrowingMethodWithoutParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: () async throws -> Void
        ) async throws -> Void
    ) async rethrows {
        let (sut, invoke) = SUT.makeMethod()

        try await test(sut, invoke)
    }
}
