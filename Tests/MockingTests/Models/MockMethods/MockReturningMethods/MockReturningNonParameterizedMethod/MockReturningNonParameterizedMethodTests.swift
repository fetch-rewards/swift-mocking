//
//  MockReturningNonParameterizedMethodTests.swift
//
//  Copyright © 2025 Fetch.
//

import Testing
@testable import Mocking

struct MockReturningNonParameterizedMethodTests {

    // MARK: Typealiases

    typealias SUT = MockReturningNonParameterizedMethod<ReturnValue>
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

            _ = invoke()
        }

        reset()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    @Test
    func callCount() {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.callCount == .zero)

        _ = invoke()
        #expect(sut.callCount == 1)

        reset()
        #expect(sut.callCount == .zero)
    }

    // MARK: Returned Values Tests

    @Test
    func returnedValues() {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.returnedValues.isEmpty)

        _ = invoke()
        #expect(sut.returnedValues == [5])

        sut.implementation = .uncheckedInvokes { 10 }

        _ = invoke()
        #expect(sut.returnedValues == [5, 10])

        reset()
        #expect(sut.returnedValues.isEmpty)
    }

    // MARK: Last Returned Value Tests

    @Test
    func lastReturnedValue() {
        let (sut, invoke, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { 5 }

        #expect(sut.lastReturnedValue == nil)

        _ = invoke()
        #expect(sut.lastReturnedValue == 5)

        sut.implementation = .uncheckedInvokes { 10 }

        _ = invoke()
        #expect(sut.lastReturnedValue == 10)

        reset()
        #expect(sut.lastReturnedValue == nil)
    }
}

// MARK: - Helpers

extension MockReturningNonParameterizedMethodTests {
    private func sut() -> (
        method: SUT,
        invoke: () -> ReturnValue,
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
