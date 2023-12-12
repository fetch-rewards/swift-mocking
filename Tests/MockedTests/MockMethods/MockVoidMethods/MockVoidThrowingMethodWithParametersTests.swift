//
//  MockVoidThrowingMethodWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidThrowingMethodWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidThrowingMethodWithParameters<Arguments>
    typealias Arguments = (string: String, boolean: Bool)

    // MARK: Call Count Tests

    func testCallCount() throws {
        try self.withSUT { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            try invoke(("a", true))
            XCTAssertEqual(sut.callCount, 1)

            sut.error = URLError(.badURL)

            do {
                try invoke(("b", false))
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

    func testInvocations() throws {
        try self.withSUT { sut, invoke in
            XCTAssertTrue(sut.invocations.isEmpty)

            try invoke(("a", true))
            XCTAssertEqual(sut.invocations.count, 1)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)

            sut.error = URLError(.badURL)

            do {
                try invoke(("b", false))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)
                XCTAssertEqual(sut.invocations.count, 2)
                XCTAssertEqual(sut.invocations.first?.string, "a")
                XCTAssertEqual(sut.invocations.first?.boolean, true)
                XCTAssertEqual(sut.invocations.last?.string, "b")
                XCTAssertEqual(sut.invocations.last?.boolean, false)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }
        }
    }

    // MARK: Last Invocation Tests

    func testLastInvocation() throws {
        try self.withSUT { sut, invoke in
            XCTAssertNil(sut.lastInvocation)

            try invoke(("a", true))
            XCTAssertEqual(sut.lastInvocation?.string, "a")
            XCTAssertEqual(sut.lastInvocation?.boolean, true)

            sut.error = URLError(.badURL)

            do {
                try invoke(("b", false))
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)
                XCTAssertEqual(sut.lastInvocation?.string, "b")
                XCTAssertEqual(sut.lastInvocation?.boolean, false)
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }
        }
    }

    // MARK: Thrown Errors Tests

    func testThrownErrors() throws {
        try self.withSUT { sut, invoke in
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            try invoke(("a", true))
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            sut.error = URLError(.badURL)

            do {
                try invoke(("b", false))
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
                try invoke(("c", true))
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

            try invoke(("a", true))
            XCTAssertNil(sut.lastThrownError)

            sut.error = URLError(.badURL)

            do {
                try invoke(("b", false))
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
                try invoke(("c", true))
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

extension MockVoidThrowingMethodWithParametersTests {
    private func withSUT(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) throws -> Void
        ) throws -> Void
    ) rethrows {
        let (sut, invoke) = SUT.makeMethod()

        try test(sut, invoke)
    }
}
