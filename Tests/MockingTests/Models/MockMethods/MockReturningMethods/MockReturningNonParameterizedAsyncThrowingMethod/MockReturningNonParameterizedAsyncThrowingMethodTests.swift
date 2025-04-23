//
//  MockReturningNonParameterizedAsyncThrowingMethodTests.swift
//  MockingTests
//
//  Created by Gray Campbell on 12/7/23.
//

import Foundation
import Testing
@testable import Mocking

struct MockReturningNonParameterizedAsyncThrowingMethodTests {

    // MARK: Typealiases

    typealias SUT = MockReturningNonParameterizedAsyncThrowingMethod<ReturnValue>
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

            _ = try await invoke()
        }

        reset()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    @Test
    func callCount() async throws {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.callCount == .zero)

        _ = try await invoke()
        #expect(sut.callCount == 1)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        await #expect(throws: URLError(.badURL)) {
            _ = try await invoke()
        }
        #expect(sut.callCount == 2)

        reset()
        #expect(sut.callCount == .zero)
    }

    // MARK: Returned Values Tests

    @Test
    func returnedValues() async throws {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.returnedValues.isEmpty)

        _ = try await invoke()
        #expect(sut.returnedValues.count == 1)
        #expect(try sut.returnedValues.first?.get() == 5)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        await #expect(throws: URLError(.badURL)) {
            _ = try await invoke()
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
    func lastReturnedValue() async throws {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.lastReturnedValue == nil)

        _ = try await invoke()
        #expect(try sut.lastReturnedValue?.get() == 5)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        await #expect(throws: URLError(.badURL)) {
            _ = try await invoke()
        }
        #expect(throws: URLError(.badURL)) {
            _ = try sut.lastReturnedValue?.get()
        }

        reset()
        #expect(sut.lastReturnedValue == nil)
    }
}

// MARK: - Helpers

extension MockReturningNonParameterizedAsyncThrowingMethodTests {
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
