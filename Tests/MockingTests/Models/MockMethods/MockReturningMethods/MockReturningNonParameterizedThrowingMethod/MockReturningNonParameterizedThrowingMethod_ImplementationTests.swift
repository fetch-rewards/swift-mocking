//
//  MockReturningNonParameterizedThrowingMethod_ImplementationTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockReturningNonParameterizedThrowingMethod_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockReturningNonParameterizedThrowingMethod<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() throws {
        let sut: SUT = .unimplemented
        let returnValue = try sut()

        #expect(returnValue == nil)
    }

    @Test
    func uncheckedInvokes() throws {
        let sut: SUT = .uncheckedInvokes { 5 }
        let returnValue = try sut()

        #expect(returnValue == 5)
    }

    @Test
    func invokes() throws {
        let sut: SUT = .invokes { 5 }
        let returnValue = try sut()

        #expect(returnValue == 5)
    }

    @Test
    func `throws`() throws {
        let sut: SUT = .throws(URLError(.badURL))

        #expect(throws: URLError(.badURL)) {
            _ = try sut()
        }
    }

    @Test
    func uncheckedReturns() throws {
        let sut: SUT = .uncheckedReturns(5)
        let returnValue = try sut()

        #expect(returnValue == 5)
    }

    @Test
    func returns() throws {
        let sut: SUT = .returns(5)
        let returnValue = try sut()

        #expect(returnValue == 5)
    }
}
