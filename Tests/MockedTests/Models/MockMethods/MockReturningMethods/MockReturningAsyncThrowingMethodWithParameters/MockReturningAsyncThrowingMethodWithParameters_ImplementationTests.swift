//
//  MockReturningAsyncThrowingMethodWithParameters_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 7/18/24.
//

import XCTest
@testable import Mocked

final class MockReturningAsyncThrowingMethodWithParameters_ImplementationTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockReturningAsyncThrowingMethodWithParameters<Arguments, ReturnValue>
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    func testReturnsCallAsFunction() async throws {
        let sut: SUT = .returns { arguments in
            XCTAssertEqual(arguments.string, "A")
            XCTAssertTrue(arguments.boolean)

            return 5
        }

        let returnValue = try await sut(
            arguments: ("A", true),
            description: self.description()
        )

        XCTAssertEqual(returnValue, 5)
    }

    func testReturnsConstructorCallAsFunction() async throws {
        let sut: SUT = .returns(5)

        let returnValue = try await sut(
            arguments: ("A", true),
            description: self.description()
        )

        XCTAssertEqual(returnValue, 5)
    }

    func testThrowsCallAsFunction() async throws {
        let sut: SUT = .throws { arguments in
            XCTAssertEqual(arguments.string, "A")
            XCTAssertTrue(arguments.boolean)

            return URLError(.badURL)
        }

        do {
            _ = try await sut(
                arguments: ("A", true),
                description: self.description()
            )
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
            _ = try await sut(
                arguments: ("A", true),
                description: self.description()
            )
            XCTFail("Expected sut to throw an error")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badURL)
        } catch {
            XCTFail("Expected \(error) to equal URLError(.badURL)")
        }
    }
}

// MARK: - Helpers

extension MockReturningAsyncThrowingMethodWithParameters_ImplementationTests {
    private func description() -> MockImplementationDescription {
        MockImplementationDescription(
            type: Self.self,
            member: "sut"
        )
    }
}
