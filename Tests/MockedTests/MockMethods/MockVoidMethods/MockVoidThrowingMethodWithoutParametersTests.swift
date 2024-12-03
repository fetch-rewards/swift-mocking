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

    // MARK: Implementation Tests

    func testImplementationDefaultValue() async {
        let (sut, _, _) = SUT.makeMethod()

        guard case .unimplemented = sut.implementation else {
            XCTFail("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    func testCallCount() throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        XCTAssertEqual(sut.callCount, .zero)

        try invoke()
        XCTAssertEqual(sut.callCount, 1)

        sut.implementation = .throws(URLError(.badURL))

        do {
            try invoke()
            XCTFail("Expected invoke to throw an error")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badURL)
        } catch {
            XCTFail("Expected \(error) to equal URLError(.badURL)")
        }

        XCTAssertEqual(sut.callCount, 2)

        reset()
        XCTAssertEqual(sut.callCount, .zero)
    }

    // MARK: Thrown Errors Tests

    func testThrownErrors() throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        XCTAssertTrue(sut.thrownErrors.isEmpty)

        try invoke()
        XCTAssertTrue(sut.thrownErrors.isEmpty)

        sut.implementation = .throws(URLError(.badURL))

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

        sut.implementation = .throws(URLError(.badServerResponse))

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

        reset()
        XCTAssertTrue(sut.thrownErrors.isEmpty)
    }

    // MARK: Last Thrown Error Tests

    func testLastThrownError() throws {
        let (sut, invoke, reset) = SUT.makeMethod()

        XCTAssertNil(sut.lastThrownError)

        try invoke()
        XCTAssertNil(sut.lastThrownError)

        sut.implementation = .throws(URLError(.badURL))

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

        sut.implementation = .throws(URLError(.badServerResponse))

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

        reset()
        XCTAssertNil(sut.lastThrownError)
    }
}
