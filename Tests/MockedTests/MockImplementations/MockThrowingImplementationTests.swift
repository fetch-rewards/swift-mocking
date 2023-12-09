//
//  MockThrowingImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/8/23.
//

import XCTest
@testable import Mocked

final class MockThrowingImplementationTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockThrowingImplementation<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    func testReturnsCallAsFunction() throws {
        let sut: SUT = .returns(5)

        let returnValue = try sut(description: self.description())

        XCTAssertEqual(returnValue, 5)
    }

    func testThrowsCallAsFunction() throws {
        let sut: SUT = .throws(URLError(.badURL))

        do {
            _ = try sut(description: self.description())
            XCTFail("Expected sut to throw an error")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badURL)
        } catch {
            XCTFail("Expected \(error) to equal URLError(.badURL)")
        }
    }
}

// MARK: - Helpers

extension MockThrowingImplementationTests {
    private func description() -> MockImplementationDescription {
        MockImplementationDescription(
            type: Self.self,
            member: "sut"
        )
    }
}
