//
//  MockVoidThrowingMethodWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidThrowingMethodWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidThrowingMethodWithoutParameters

    // MARK: Call Count Tests

    func testCallCount() throws {
        try self.withSUT { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            try invoke()
            XCTAssertEqual(sut.callCount, 1)

            sut.error = URLError(.badURL)

            do {
                try invoke()
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

    func testThrownErrors() throws {
        try self.withSUT { sut, invoke in
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            try invoke()
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            sut.error = URLError(.badURL)

            do {
                try invoke()
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
                try invoke()
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

    func testLastThrownError() throws {
        try self.withSUT { sut, invoke in
            XCTAssertNil(sut.lastThrownError)

            try invoke()
            XCTAssertNil(sut.lastThrownError)

            sut.error = URLError(.badURL)

            do {
                try invoke()
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
                try invoke()
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

extension MockVoidThrowingMethodWithoutParametersTests {
    private func withSUT(
        test: (
            _ sut: SUT,
            _ invoke: () throws -> Void
        ) throws -> Void
    ) rethrows {
        let (sut, invoke) = SUT.makeMethod()

        try test(sut, invoke)
    }
}
