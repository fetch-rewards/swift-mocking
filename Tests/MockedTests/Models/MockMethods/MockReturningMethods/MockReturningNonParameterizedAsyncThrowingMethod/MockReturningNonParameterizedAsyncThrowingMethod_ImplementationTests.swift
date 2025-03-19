//
//  MockReturningNonParameterizedAsyncThrowingMethod_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 7/18/24.
//

import Foundation
import Testing
@testable import Mocked

struct MockReturningNonParameterizedAsyncThrowingMethod_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockReturningNonParameterizedAsyncThrowingMethod<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async throws {
        let sut: SUT = .unimplemented
        let returnValue = try await sut()

        #expect(returnValue == nil)
    }

    @Test
    func uncheckedInvokes() async throws {
        let sut: SUT = .uncheckedInvokes { 5 }
        let returnValue = try await sut()

        #expect(returnValue == 5)
    }

    @Test
    func invokes() async throws {
        let sut: SUT = .invokes { 5 }
        let returnValue = try await sut()

        #expect(returnValue == 5)
    }

    @Test
    func `throws`() async throws {
        let sut: SUT = .throws(URLError(.badURL))

        await #expect(throws: URLError(.badURL)) {
            _ = try await sut()
        }
    }

    @Test
    func uncheckedReturns() async throws {
        let sut: SUT = .uncheckedReturns(5)
        let returnValue = try await sut()

        #expect(returnValue == 5)
    }

    @Test
    func returns() async throws {
        let sut: SUT = .returns(5)
        let returnValue = try await sut()

        #expect(returnValue == 5)
    }
}
