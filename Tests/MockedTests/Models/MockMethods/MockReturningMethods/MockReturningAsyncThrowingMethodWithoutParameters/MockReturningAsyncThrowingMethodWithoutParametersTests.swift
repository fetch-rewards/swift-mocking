//
//  MockReturningAsyncThrowingMethodWithoutParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningAsyncThrowingMethodWithoutParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningAsyncThrowingMethodWithoutParameters<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Implementation Tests

    func testImplementationDefaultValue() async {
        let (sut, _, _) = self.sut()

        guard case .unimplemented = sut.implementation else {
            XCTFail("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    func testCallCount() async throws {
        let (sut, invoke, reset) = self.sut()

        XCTAssertEqual(sut.callCount, .zero)

        sut.implementation = .returns(5)

        _ = try await invoke()
        XCTAssertEqual(sut.callCount, 1)

        sut.implementation = .throws(URLError(.badURL))

        do {
            _ = try await invoke()
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

    func testReturnedValues() async throws {
        let (sut, invoke, reset) = self.sut()

        XCTAssertTrue(sut.returnedValues.isEmpty)

        sut.implementation = .returns(5)

        _ = try await invoke()
        XCTAssertEqual(sut.returnedValues.count, 1)
        XCTAssertEqual(try sut.returnedValues.first?.get(), 5)

        sut.implementation = .throws(URLError(.badURL))

        do {
            _ = try await invoke()
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

    func testLastReturnedValue() async throws {
        let (sut, invoke, reset) = self.sut()

        XCTAssertNil(sut.lastReturnedValue)

        sut.implementation = .returns(5)

        _ = try await invoke()
        XCTAssertEqual(try sut.lastReturnedValue?.get(), 5)

        sut.implementation = .throws(URLError(.badURL))

        do {
            _ = try await invoke()
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

extension MockReturningAsyncThrowingMethodWithoutParametersTests {
    private func sut() -> (
        method: SUT,
        invoke: () async throws -> ReturnValue,
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
