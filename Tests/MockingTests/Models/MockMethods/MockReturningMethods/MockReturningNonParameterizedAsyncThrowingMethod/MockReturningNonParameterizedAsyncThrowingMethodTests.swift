//
//  MockReturningNonParameterizedAsyncThrowingMethodTests.swift
//
//  Copyright © 2026 Fetch.
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

        try await TestBarrier.executeConcurrently {
            _ = try await invoke()
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        await #expect(throws: URLError(.badURL)) {
            try await TestBarrier.executeConcurrently {
                _ = try await invoke()
            }
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount * 2)

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.callCount == .zero)
    }

    // MARK: Returned Values Tests

    @Test
    func returnedValues() async throws {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.returnedValues.isEmpty)

        try await TestBarrier.executeConcurrently {
            _ = try await invoke()
        }
        #expect(sut.returnedValues.count == TestBarrier.defaultTaskCount)
        #expect(
            sut.returnedValues.allSatisfy { returnedValue in
                (try? returnedValue.get()) == 5
            }
        )

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        await #expect(throws: URLError(.badURL)) {
            try await TestBarrier.executeConcurrently {
                _ = try await invoke()
            }
        }
        #expect(sut.returnedValues.count == TestBarrier.defaultTaskCount * 2)
        #expect(
            sut.returnedValues.prefix(TestBarrier.defaultTaskCount).allSatisfy { returnedValue in
                (try? returnedValue.get()) == 5
            }
        )
        #expect(
            sut.returnedValues.suffix(TestBarrier.defaultTaskCount).allSatisfy { returnedValue in
                do {
                    _ = try returnedValue.get()
                    return false
                } catch URLError.badURL {
                    return true
                } catch {
                    return false
                }
            }
        )

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.returnedValues.isEmpty)
    }

    // MARK: Last Returned Value Tests

    @Test
    func lastReturnedValue() async throws {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.lastReturnedValue == nil)

        try await TestBarrier.executeConcurrently {
            _ = try await invoke()
        }
        #expect(try sut.lastReturnedValue?.get() == 5)

        sut.implementation = .uncheckedInvokes {
            throw URLError(.badURL)
        }

        await #expect(throws: URLError(.badURL)) {
            try await TestBarrier.executeConcurrently {
                _ = try await invoke()
            }
        }
        #expect(throws: URLError(.badURL)) {
            try sut.lastReturnedValue?.get()
        }

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.lastReturnedValue == nil)
    }
}

// MARK: - Helpers

extension MockReturningNonParameterizedAsyncThrowingMethodTests {
    private func sut() -> (
        method: SUT,
        invoke: @Sendable () async throws -> ReturnValue,
        reset: @Sendable () -> Void
    ) {
        SUT.makeMethod(
            exposedMethodDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )
    }
}
