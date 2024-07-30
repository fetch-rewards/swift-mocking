//
//  MockReturningAsyncThrowingMethodWithoutParameters_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 7/18/24.
//

import XCTest
@testable import Mocked

final class MockReturningAsyncThrowingMethodWithoutParameters_ImplementationTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockReturningAsyncThrowingMethodWithoutParameters<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    func testReturnsCallAsFunction() async throws {
        let sut: SUT = .returns { 5 }

        let returnValue = try await sut(description: self.description())

        XCTAssertEqual(returnValue, 5)
    }

    func testReturnsConstructorCallAsFunction() async throws {
        let sut: SUT = .returns(5)

        let returnValue = try await sut(description: self.description())

        XCTAssertEqual(returnValue, 5)
    }

    func testThrowsCallAsFunction() async throws {
        let sut: SUT = .throws { URLError(.badURL) }

        do {
            _ = try await sut(description: self.description())
            XCTFail("Expected sut to throw an error")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badURL)
        } catch {
            XCTFail("Expected \(error) to equal URLError(.badURL)")
        }
    }

    func testThrowsConstructorCallAsFunction() async throws {
        let sut: SUT = .throws(URLError(.badURL))

        do {
            _ = try await sut(description: self.description())
            XCTFail("Expected sut to throw an error")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badURL)
        } catch {
            XCTFail("Expected \(error) to equal URLError(.badURL)")
        }
    }
}

// MARK: - Helpers

extension MockReturningAsyncThrowingMethodWithoutParameters_ImplementationTests {
    private func description() -> MockImplementationDescription {
        MockImplementationDescription(
            type: Self.self,
            member: "sut"
        )
    }
}
