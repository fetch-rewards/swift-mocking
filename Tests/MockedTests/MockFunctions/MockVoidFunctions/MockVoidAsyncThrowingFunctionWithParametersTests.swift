//
//  MockVoidAsyncThrowingFunctionWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidAsyncThrowingFunctionWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidAsyncThrowingFunctionWithParameters<Arguments>
    typealias Arguments = (string: String, boolean: Bool)

    // MARK: Call Count Tests

    func testCallCount() async throws {
        try await self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            _ = try await invoke(("a", true))
            XCTAssertEqual(sut.callCount, 1)

            sut.error = URLError(.badURL)

            do {
                _ = try await invoke(("b", false))
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
        try await self.test { sut, invoke in
            XCTAssertTrue(sut.invocations.isEmpty)

            _ = try await invoke(("a", true))
            XCTAssertEqual(sut.invocations.count, 1)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)

            _ = try await invoke(("b", false))
            XCTAssertEqual(sut.invocations.count, 2)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)
            XCTAssertEqual(sut.invocations.last?.string, "b")
            XCTAssertEqual(sut.invocations.last?.boolean, false)
        }
    }

    // MARK: Latest Invocation Tests

    func testLatestInvocation() async throws {
        try await self.test { sut, invoke in
            XCTAssertNil(sut.latestInvocation)

            _ = try await invoke(("a", true))
            XCTAssertEqual(sut.latestInvocation?.string, "a")
            XCTAssertEqual(sut.latestInvocation?.boolean, true)

            _ = try await invoke(("b", false))
            XCTAssertEqual(sut.latestInvocation?.string, "b")
            XCTAssertEqual(sut.latestInvocation?.boolean, false)
        }
    }

    // MARK: Errors Tests

    func testErrors() async throws {
        try await self.test { sut, invoke in
            XCTAssertTrue(sut.errors.isEmpty)

            _ = try await invoke(("a", true))
            XCTAssertTrue(sut.errors.isEmpty)

            sut.error = URLError(.badURL)

            do {
                _ = try await invoke(("b", false))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)
                XCTAssertEqual(sut.errors.count, 1)

                let firstError = try XCTUnwrap(sut.errors.first as? URLError)

                XCTAssertEqual(firstError.code, .badURL)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }

            sut.error = URLError(.badServerResponse)

            do {
                _ = try await invoke(("c", true))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badServerResponse)
                XCTAssertEqual(sut.errors.count, 2)

                let firstError = try XCTUnwrap(sut.errors.first as? URLError)
                let lastError = try XCTUnwrap(sut.errors.last as? URLError)

                XCTAssertEqual(firstError.code, .badURL)
                XCTAssertEqual(lastError.code, .badServerResponse)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badServerResponse)")
            }
        }
    }

    // MARK: Latest Error Tests

    func testLatestError() async throws {
        try await self.test { sut, invoke in
            XCTAssertNil(sut.latestError)

            _ = try await invoke(("a", true))
            XCTAssertNil(sut.latestError)

            sut.error = URLError(.badURL)

            do {
                _ = try await invoke(("b", false))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)

                let latestError = try XCTUnwrap(sut.latestError as? URLError)

                XCTAssertEqual(latestError.code, .badURL)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }

            sut.error = URLError(.badServerResponse)

            do {
                _ = try await invoke(("c", true))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badServerResponse)

                let latestError = try XCTUnwrap(sut.latestError as? URLError)

                XCTAssertEqual(latestError.code, .badServerResponse)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badServerResponse)")
            }
        }
    }
}

// MARK: - Helpers

extension MockVoidAsyncThrowingFunctionWithParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) async throws -> Void
        ) async throws -> Void
    ) async rethrows {
        let (sut, invoke) = SUT.makeFunction()

        try await test(sut, invoke)
    }
}
