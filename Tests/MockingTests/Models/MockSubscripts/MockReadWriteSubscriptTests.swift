//
//  MockReadWriteSubscriptTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockReadWriteSubscriptTests {

    // MARK: Typealiases

    typealias SUT = MockReadWriteSubscript<Arguments, Value>
    typealias Arguments = String
    typealias Value = Int

    // MARK: Getter Tests

    @Test
    func getter() async {
        let (sut, get, _, _) = self.sut()

        await confirmation(expectedCount: 1) { confirmation in
            sut.getter.implementation = .uncheckedInvokes { _ in
                confirmation.confirm()
                return 5
            }

            _ = get("a")
        }
    }

    // MARK: Setter Tests

    @Test
    func setter() async {
        let (sut, _, set, _) = self.sut()

        await confirmation(expectedCount: 1) { confirmation in
            sut.setter.implementation = .uncheckedInvokes { _, _ in
                confirmation.confirm()
            }

            set("a", 5)
        }
    }

    // MARK: Reset Tests

    @Test
    func reset() async throws {
        let (sut, get, set, reset) = self.sut()

        sut.getter.implementation = .uncheckedInvokes { _ in 5 }

        try await TestBarrier.executeConcurrently {
            _ = get("a")
        }
        #expect(sut.getter.callCount == TestBarrier.defaultTaskCount)

        try await TestBarrier.executeConcurrently {
            set("a", 5)
        }
        #expect(sut.setter.callCount == TestBarrier.defaultTaskCount)

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.getter.callCount == .zero)
        #expect(sut.setter.callCount == .zero)

        guard case .unimplemented = sut.getter.implementation else {
            Issue.record("Expected getter implementation to equal .unimplemented")
            return
        }

        guard case .unimplemented = sut.setter.implementation else {
            Issue.record("Expected setter implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Non-Sendable Overload Tests

    @Test
    func makeSubscript_nonSendable() {
        let box = NonSendableBox()
        let (sut, get, set, reset) = MockReadWriteSubscript<String, NonSendableBox>.makeSubscript(
            exposedSubscriptDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )

        sut.getter.implementation = .uncheckedInvokes { _ in box }
        _ = get("a")
        #expect(sut.getter.callCount == 1)

        set("a", NonSendableBox())
        #expect(sut.setter.callCount == 1)

        reset()
        #expect(sut.getter.callCount == .zero)
        #expect(sut.setter.callCount == .zero)
    }
}

// MARK: - Helpers

extension MockReadWriteSubscriptTests {
    private func sut() -> (
        subscript: SUT,
        get: @Sendable (Arguments) -> Value,
        set: @Sendable (Arguments, Value) -> Void,
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
