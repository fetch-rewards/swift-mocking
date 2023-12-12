//
//  MockReturningThrowingMethodWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningThrowingMethodWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningThrowingMethodWithoutParameters<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Implementation Tests

    func testImplementationDefaultValue() {
        self.withSUT { sut, _ in
            guard case .unimplemented = sut.implementation else {
                XCTFail("Expected implementation to equal .unimplemented")
                return
            }
        }
    }

    // MARK: Call Count Tests

    func testCallCount() throws {
        try self.withSUT { sut, invoke in
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

    // MARK: Returned Values Tests

    func testReturnedValues() throws {
        try self.withSUT { sut, invoke in
            XCTAssertTrue(sut.returnedValues.isEmpty)

            sut.implementation = .returns(5)

            _ = try invoke()
            XCTAssertEqual(sut.returnedValues.count, 1)
            XCTAssertEqual(try sut.returnedValues.first?.get(), 5)

            sut.implementation = .throws(URLError(.badURL))

            do {
                _ = try invoke()
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)
                XCTAssertEqual(sut.returnedValues.count, 2)
                XCTAssertEqual(try sut.returnedValues.first?.get(), 5)

                do {
                    _ = try sut.returnedValues.last?.get()
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

    // MARK: Last Returned Value Tests

    func testLastReturnedValue() throws {
        try self.withSUT { sut, invoke in
            XCTAssertNil(sut.lastReturnedValue)

            sut.implementation = .returns(5)

            _ = try invoke()
            XCTAssertEqual(try sut.lastReturnedValue?.get(), 5)

            sut.implementation = .throws(URLError(.badURL))

            do {
                _ = try invoke()
                XCTFail("Expected invoke to throw an error")
            } catch let error as URLError {
                XCTAssertEqual(error.code, .badURL)

                do {
                    _ = try sut.lastReturnedValue?.get()
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
}

// MARK: - Helpers

extension MockReturningThrowingMethodWithoutParametersTests {
    private func withSUT(
        test: (
            _ sut: SUT,
            _ invoke: () throws -> ReturnValue
        ) throws -> Void
    ) rethrows {
        let (sut, invoke) = SUT.makeMethod(
            exposedMethodDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )

        try test(sut, invoke)
    }
}
