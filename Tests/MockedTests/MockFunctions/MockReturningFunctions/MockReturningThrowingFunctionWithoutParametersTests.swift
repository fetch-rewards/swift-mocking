//
//  MockReturningThrowingFunctionWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningThrowingFunctionWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningThrowingFunctionWithoutParameters<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Implementation Tests

    func testImplementationDefaultValue() {
        self.test { sut, _ in
            guard case .unimplemented = sut.implementation else {
                XCTFail("Expected implementation to equal .unimplemented")
                return
            }
        }
    }

    // MARK: Call Count Tests

    func testCallCount() throws {
        try self.test { sut, invoke in
            XCTAssertEqual(sut.callCount, .zero)

            sut.implementation = .returns(5)

            _ = try invoke()
            XCTAssertEqual(sut.callCount, 1)

            sut.implementation = .throws(URLError(.badURL))

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

    // MARK: Return Values Tests

    func testReturnValues() throws {
        try self.test { sut, invoke in
            XCTAssertTrue(sut.returnValues.isEmpty)

            sut.implementation = .returns(5)

            _ = try invoke()
            XCTAssertEqual(sut.returnValues.count, 1)
            XCTAssertEqual(try sut.returnValues.first?.get(), 5)

            sut.implementation = .throws(URLError(.badURL))

            do {
                _ = try invoke()
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)
                XCTAssertEqual(sut.returnValues.count, 2)
                XCTAssertEqual(try sut.returnValues.first?.get(), 5)

                do {
                    _ = try sut.returnValues.last?.get()
                    XCTFail("Expected last return value to throw an error")
                } catch let error as URLError {
                    XCTAssertEqual(error.code, .badURL)
                } catch {
                    XCTFail("Expected \(error) to equal URLError(.badURL)")
                }
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }
        }
    }

    // MARK: Latest Return Value Tests

    func testLatestReturnValue() throws {
        try self.test { sut, invoke in
            XCTAssertNil(sut.latestReturnValue)

            sut.implementation = .returns(5)

            _ = try invoke()
            XCTAssertEqual(try sut.latestReturnValue?.get(), 5)

            sut.implementation = .throws(URLError(.badURL))

            do {
                _ = try invoke()
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)

                do {
                    _ = try sut.latestReturnValue?.get()
                    XCTFail("Expected latest return value to throw an error")
                } catch let error as URLError {
                    XCTAssertEqual(error.code, .badURL)
                } catch {
                    XCTFail("Expected \(error) to equal URLError(.badURL)")
                }
            } catch {
                XCTFail("Expected \(error) to equal URLError(.badURL)")
            }
        }
    }
}

// MARK: - Helpers

extension MockReturningThrowingFunctionWithoutParametersTests {
    private func test(
        test: (
            _ sut: SUT,
            _ invoke: () throws -> ReturnValue
        ) throws -> Void
    ) rethrows {
        let (sut, invoke) = SUT.makeFunction(
            exposedFunctionDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )

        try test(sut, invoke)
    }
}
