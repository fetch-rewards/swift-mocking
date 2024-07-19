//
//  MockReturningThrowingMethodWithParametersTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import XCTest
@testable import Mocked

final class MockReturningThrowingMethodWithParametersTests: XCTestCase {

    // MARK: Typealiases

    typealias SUT = MockReturningThrowingMethodWithParameters<Arguments, ReturnValue>
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int

    // MARK: Implementation Tests

    func testImplementationDefaultValue() {
        let (sut, _) = self.sut()

        guard case .unimplemented = sut.implementation else {
            XCTFail("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    func testCallCount() throws {
        let (sut, invoke) = self.sut()

        XCTAssertEqual(sut.callCount, .zero)

        sut.implementation = .returns(5)

        _ = try invoke(("a", true))
        XCTAssertEqual(sut.callCount, 1)

        sut.implementation = .throws(URLError(.badURL))

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

    // MARK: Invocations Tests

    func testInvocations() throws {
        let (sut, invoke) = self.sut()

        XCTAssertTrue(sut.invocations.isEmpty)

        sut.implementation = .returns(5)

        _ = try invoke(("a", true))
        XCTAssertEqual(sut.invocations.count, 1)
        XCTAssertEqual(sut.invocations.first?.string, "a")
        XCTAssertEqual(sut.invocations.first?.boolean, true)

        sut.implementation = .throws(URLError(.badURL))

        do {
            _ = try invoke(("b", false))
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

    // MARK: Last Invocation Tests

    func testLastInvocation() throws {
        let (sut, invoke) = self.sut()

        XCTAssertNil(sut.lastInvocation)

        sut.implementation = .returns(5)

        _ = try invoke(("a", true))
        XCTAssertEqual(sut.lastInvocation?.string, "a")
        XCTAssertEqual(sut.lastInvocation?.boolean, true)

        sut.implementation = .throws(URLError(.badURL))

        do {
            _ = try invoke(("b", false))
            XCTFail("Expected invoke to throw an error")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badURL)
            XCTAssertEqual(sut.lastInvocation?.string, "b")
            XCTAssertEqual(sut.lastInvocation?.boolean, false)
        } catch {
            XCTFail("Expected \(error) to equal URLError(.badURL)")
        }
    }

    // MARK: Returned Values Tests

    func testReturnedValues() throws {
        let (sut, invoke) = self.sut()

        XCTAssertTrue(sut.returnedValues.isEmpty)

        sut.implementation = .returns(5)

        _ = try invoke(("a", true))
        XCTAssertEqual(sut.returnedValues.count, 1)
        XCTAssertEqual(try sut.returnedValues.first?.get(), 5)

        sut.implementation = .throws(URLError(.badURL))

        do {
            _ = try invoke(("b", false))
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

    // MARK: Last Returned Value Tests

    func testLastReturnedValue() throws {
        let (sut, invoke) = self.sut()

        XCTAssertNil(sut.lastReturnedValue)

        sut.implementation = .returns(5)

        _ = try invoke(("a", true))
        XCTAssertEqual(try sut.lastReturnedValue?.get(), 5)

        sut.implementation = .throws(URLError(.badURL))

        do {
            _ = try invoke(("b", false))
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

// MARK: - Helpers

extension MockReturningThrowingMethodWithParametersTests {
    private func sut() -> (
        method: SUT,
        invoke: (Arguments) throws -> ReturnValue
    ) {
        SUT.makeMethod(
            exposedMethodDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )
    }
}
