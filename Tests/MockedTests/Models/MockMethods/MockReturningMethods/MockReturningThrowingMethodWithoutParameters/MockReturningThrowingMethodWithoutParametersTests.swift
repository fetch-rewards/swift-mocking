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
        let (sut, _, _) = self.sut()

        guard case .unimplemented = sut.implementation else {
            XCTFail("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    func testCallCount() throws {
        let (sut, invoke, reset) = self.sut()

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

        reset()
        XCTAssertEqual(sut.callCount, .zero)
    }

    // MARK: Returned Values Tests

    func testReturnedValues() throws {
        let (sut, invoke, reset) = self.sut()

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

        reset()
        XCTAssertTrue(sut.returnedValues.isEmpty)
    }

    // MARK: Last Returned Value Tests

    func testLastReturnedValue() throws {
        let (sut, invoke, reset) = self.sut()

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

        reset()
        XCTAssertNil(sut.lastReturnedValue)
    }
}

// MARK: - Helpers

extension MockReturningThrowingMethodWithoutParametersTests {
    private func sut() -> (
        method: SUT,
        invoke: () throws -> ReturnValue,
        reset: () -> Void
    ) {
        SUT.makeMethod(
            exposedMethodDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )
    }
}
