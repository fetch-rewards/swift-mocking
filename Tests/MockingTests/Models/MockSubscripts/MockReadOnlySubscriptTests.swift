//
//  MockReadOnlySubscriptTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockReadOnlySubscriptTests {

    // MARK: Typealiases

    typealias SUT = MockReadOnlySubscript<Arguments, Value>
    typealias Arguments = String
    typealias Value = Int

    // MARK: Getter Tests

    @Test
    func getter() async {
        let (sut, get, _) = self.sut()

        await confirmation(expectedCount: 1) { confirmation in
            sut.getter.implementation = .uncheckedInvokes { _ in
                confirmation.confirm()
                return 5
            }

            _ = get("a")
        }
    }

    // MARK: Reset Tests

    @Test
    func reset() async throws {
        let (sut, get, reset) = self.sut()

        sut.getter.implementation = .uncheckedInvokes { _ in 5 }

        try await TestBarrier.executeConcurrently {
            _ = get("a")
        }
        #expect(sut.getter.callCount == TestBarrier.defaultTaskCount)

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.getter.callCount == .zero)

        guard case .unimplemented = sut.getter.implementation else {
            Issue.record("Expected getter implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Non-Sendable Overload Tests

    @Test
    func makeSubscript_nonSendable() {
        let box = NonSendableBox()
        let (sut, get, reset) = MockReadOnlySubscript<String, NonSendableBox>.makeSubscript(
            exposedSubscriptDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )

        sut.getter.implementation = .uncheckedInvokes { _ in box }
        _ = get("a")
        #expect(sut.getter.callCount == 1)
        reset()
        #expect(sut.getter.callCount == .zero)
    }
}

// MARK: - Helpers

extension MockReadOnlySubscriptTests {
    private func sut() -> (
        subscript: SUT,
        get: @Sendable (Arguments) -> Value,
        reset: @Sendable () -> Void
    ) {
        SUT.makeSubscript(
            exposedSubscriptDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )
    }

    private final class NonSendableBox {}
}
