//
//  MockReturningNonParameterizedAsyncMethodTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockReturningNonParameterizedAsyncMethodTests {

    // MARK: Typealiases

    typealias SUT = MockReturningNonParameterizedAsyncMethod<ReturnValue>
    typealias ReturnValue = Int

    // MARK: Implementation Tests

    @Test
    func implementation() async {
        let (sut, invoke, reset) = self.sut()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }

        await confirmation(expectedCount: 1) { confirmation in
            sut.implementation = .uncheckedInvokes {
                confirmation.confirm()
                return 5
            }

            _ = await invoke()
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
            _ = await invoke()
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount)

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
            _ = await invoke()
        }
        #expect(sut.returnedValues.count == TestBarrier.defaultTaskCount)
        #expect(
            sut.returnedValues.allSatisfy { returnedValue in
                returnedValue == 5
            }
        )

        sut.implementation = .uncheckedInvokes { 10 }

        try await TestBarrier.executeConcurrently {
            _ = await invoke()
        }
        #expect(sut.returnedValues.count == TestBarrier.defaultTaskCount * 2)
        #expect(
            sut.returnedValues.prefix(TestBarrier.defaultTaskCount).allSatisfy { returnedValue in
                returnedValue == 5
            }
        )
        #expect(
            sut.returnedValues.suffix(TestBarrier.defaultTaskCount).allSatisfy { returnedValue in
                returnedValue == 10
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
            _ = await invoke()
        }
        #expect(sut.lastReturnedValue == 5)

        sut.implementation = .uncheckedInvokes { 10 }

        try await TestBarrier.executeConcurrently {
            _ = await invoke()
        }
        #expect(sut.lastReturnedValue == 10)

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.lastReturnedValue == nil)
    }
}

// MARK: - Helpers

extension MockReturningNonParameterizedAsyncMethodTests {
    private func sut() -> (
        method: SUT,
        invoke: @Sendable () async -> ReturnValue,
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
