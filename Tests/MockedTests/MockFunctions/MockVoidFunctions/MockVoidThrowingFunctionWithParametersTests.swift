//
//  MockVoidThrowingFunctionWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockVoidThrowingFunctionWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockVoidThrowingFunctionWithParameters<Arguments>
    typealias Arguments = (string: String, boolean: Bool)

    // MARK: Call Count Tests

    func testCallCount() throws {
        try self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            _ = try invoke(("a", true))
            XCTAssertEqual(sut.callCount, 1)

            sut.error = URLError(.badURL)

            do {
                _ = try invoke(("b", false))
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
        try self.test { sut, invoke in
            XCTAssertTrue(sut.invocations.isEmpty)

            _ = try invoke(("a", true))
            XCTAssertEqual(sut.invocations.count, 1)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)

            _ = try invoke(("b", false))
            XCTAssertEqual(sut.invocations.count, 2)
            XCTAssertEqual(sut.invocations.first?.string, "a")
            XCTAssertEqual(sut.invocations.first?.boolean, true)
            XCTAssertEqual(sut.invocations.last?.string, "b")
            XCTAssertEqual(sut.invocations.last?.boolean, false)
        }
    }

    // MARK: Last Invocation Tests

    func testLastInvocation() throws {
        try self.test { sut, invoke in
            XCTAssertNil(sut.lastInvocation)

            _ = try invoke(("a", true))
            XCTAssertEqual(sut.lastInvocation?.string, "a")
            XCTAssertEqual(sut.lastInvocation?.boolean, true)

            _ = try invoke(("b", false))
            XCTAssertEqual(sut.lastInvocation?.string, "b")
            XCTAssertEqual(sut.lastInvocation?.boolean, false)
        }
    }

    // MARK: Errors Tests

    func testErrors() throws {
        try self.test { sut, invoke in
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            _ = try invoke(("a", true))
            XCTAssertTrue(sut.thrownErrors.isEmpty)

            sut.error = URLError(.badURL)

            do {
                _ = try invoke(("b", false))
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
                _ = try invoke(("c", true))
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

    func testLastError() throws {
        try self.test { sut, invoke in
            XCTAssertNil(sut.lastThrownError)

            _ = try invoke(("a", true))
            XCTAssertNil(sut.lastThrownError)

            sut.error = URLError(.badURL)

            do {
                _ = try invoke(("b", false))
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
                _ = try invoke(("c", true))
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

extension MockVoidThrowingFunctionWithParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: (Arguments) throws -> Void
        ) throws -> Void
    ) rethrows {
        let (sut, invoke) = SUT.makeFunction()

        try test(sut, invoke)
    }
}
