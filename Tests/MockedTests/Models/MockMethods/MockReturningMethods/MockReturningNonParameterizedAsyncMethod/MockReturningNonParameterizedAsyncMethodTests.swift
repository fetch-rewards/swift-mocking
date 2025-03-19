//
//  MockReturningNonParameterizedAsyncMethodTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import Testing
@testable import Mocked

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
    func callCount() async {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.callCount == .zero)

        _ = await invoke()
        #expect(sut.callCount == 1)

        reset()
        #expect(sut.callCount == .zero)
    }

    // MARK: Returned Values Tests

    @Test
    func returnedValues() async {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.returnedValues.isEmpty)

        _ = await invoke()
        #expect(sut.returnedValues == [5])

        sut.implementation = .uncheckedInvokes { 10 }

        _ = await invoke()
        #expect(sut.returnedValues == [5, 10])

        reset()
        #expect(sut.returnedValues.isEmpty)
    }

    // MARK: Last Returned Value Tests

    @Test
    func lastReturnedValue() async {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.lastReturnedValue == nil)

        _ = await invoke()
        #expect(sut.lastReturnedValue == 5)

        sut.implementation = .uncheckedInvokes { 10 }

        _ = await invoke()
        #expect(sut.lastReturnedValue == 10)

        reset()
        #expect(sut.lastReturnedValue == nil)
    }
}

// MARK: - Helpers

extension MockReturningNonParameterizedAsyncMethodTests {
    private func sut() -> (
        method: SUT,
        invoke: () async -> ReturnValue,
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
