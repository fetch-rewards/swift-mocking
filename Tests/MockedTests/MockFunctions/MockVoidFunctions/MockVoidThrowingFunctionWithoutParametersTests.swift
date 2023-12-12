//
//  MockVoidThrowingFunctionWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidThrowingFunctionWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidThrowingFunctionWithoutParameters

    // MARK: Call Count Tests

    func testCallCount() throws {
        try self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            _ = try invoke()
            XCTAssertEqual(sut.callCount, 1)

            sut.error = URLError(.badURL)

            do {
                _ = try invoke()
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

    func testErrors() throws {
        try self.test { sut, invoke in
            XCTAssertTrue(sut.errors.isEmpty)

            _ = try invoke()
            XCTAssertTrue(sut.errors.isEmpty)

            sut.error = URLError(.badURL)

            do {
                _ = try invoke()
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
                _ = try invoke()
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

    func testLatestError() throws {
        try self.test { sut, invoke in
            XCTAssertNil(sut.latestError)

            _ = try invoke()
            XCTAssertNil(sut.latestError)

            sut.error = URLError(.badURL)

            do {
                _ = try invoke()
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
                _ = try invoke()
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

extension MockVoidThrowingFunctionWithoutParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: () throws -> Void
        ) throws -> Void
    ) rethrows {
        let (sut, invoke) = SUT.makeFunction()

        try test(sut, invoke)
    }
}
