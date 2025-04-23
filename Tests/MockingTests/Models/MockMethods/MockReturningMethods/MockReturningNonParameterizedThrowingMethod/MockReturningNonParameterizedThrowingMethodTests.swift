//
//  MockReturningNonParameterizedThrowingMethodTests.swift
//  MockingTests
//
//  Created by Gray Campbell on 12/7/23.
//

import Foundation
import Testing
@testable import Mocking

struct MockReturningNonParameterizedThrowingMethodTests {

    // MARK: Typealiases

    typealias SUT = MockReturningNonParameterizedThrowingMethod<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Implementation Tests

    @Test
    func implementation() async throws {
        let (sut, invoke, reset) = self.sut()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }

        try await confirmation(expectedCount: 1) { confirmation in
            sut.implementation = .uncheckedInvokes {
                confirmation.confirm()
                return 5
            }

            _ = try invoke()
        }

        reset()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    @Test
    func callCount() throws {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.callCount == .zero)

        _ = try invoke()
        #expect(sut.callCount == 1)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        #expect(throws: URLError(.badURL)) {
            _ = try invoke()
        }
        #expect(sut.callCount == 2)

        reset()
        #expect(sut.callCount == .zero)
    }

    // MARK: Returned Values Tests

    @Test
    func returnedValues() throws {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.returnedValues.isEmpty)

        _ = try invoke()
        #expect(sut.returnedValues.count == 1)
        #expect(try sut.returnedValues.first?.get() == 5)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        #expect(throws: URLError(.badURL)) {
            _ = try invoke()
        }
        #expect(sut.returnedValues.count == 2)
        #expect(try sut.returnedValues.first?.get() == 5)
        #expect(throws: URLError(.badURL)) {
            _ = try sut.returnedValues.last?.get()
        }

        reset()
        #expect(sut.returnedValues.isEmpty)
    }

    // MARK: Last Returned Value Tests

    @Test
    func lastReturnedValue() throws {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.lastReturnedValue == nil)

        _ = try invoke()
        #expect(try sut.lastReturnedValue?.get() == 5)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        #expect(throws: URLError(.badURL)) {
            _ = try invoke()
        }
        #expect(throws: URLError(.badURL)) {
            _ = try sut.lastReturnedValue?.get()
        }

        reset()
        #expect(sut.lastReturnedValue == nil)
    }
}

// MARK: - Helpers

extension MockReturningNonParameterizedThrowingMethodTests {
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
