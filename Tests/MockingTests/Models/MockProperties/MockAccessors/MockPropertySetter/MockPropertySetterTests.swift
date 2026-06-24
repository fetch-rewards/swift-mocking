//
//  MockPropertySetterTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockPropertySetterTests {

    // MARK: Typealiases

    typealias SUT = MockPropertySetter<Value>
    typealias Value = Int

    // MARK: Implementation Tests

    @Test
    func implementation() async {
        let (sut, set, reset) = self.sut()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }

        await confirmation(expectedCount: 1) { confirmation in
            sut.implementation = .uncheckedInvokes { _ in
                confirmation.confirm()
            }

            set(5)
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
        let (sut, set, reset) = self.sut()

        #expect(sut.callCount == .zero)

        try await TestBarrier.executeConcurrently {
            set(5)
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount)

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.callCount == .zero)
    }

    // MARK: Invocations Tests

    @Test
    func invocations() async throws {
        let (sut, set, reset) = self.sut()

        #expect(sut.invocations.isEmpty)

        try await TestBarrier.executeConcurrently {
            set(5)
        }
        #expect(sut.invocations.count == TestBarrier.defaultTaskCount)
        #expect(
            sut.invocations.allSatisfy { invocation in
                invocation == 5
            }
        )

        try await TestBarrier.executeConcurrently {
            set(10)
        }
        #expect(sut.invocations.count == TestBarrier.defaultTaskCount * 2)
        #expect(
            sut.invocations.prefix(TestBarrier.defaultTaskCount).allSatisfy { invocation in
                invocation == 5
            }
        )
        #expect(
            sut.invocations.suffix(TestBarrier.defaultTaskCount).allSatisfy { invocation in
                invocation == 10
            }
        )

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.invocations.isEmpty)
    }

    // MARK: Last Invocation Tests

    @Test
    func lastInvocation() async throws {
        let (sut, set, reset) = self.sut()

        #expect(sut.lastInvocation == nil)

        try await TestBarrier.executeConcurrently {
            set(5)
        }
        #expect(sut.lastInvocation == 5)

        try await TestBarrier.executeConcurrently {
            set(10)
        }
        #expect(sut.lastInvocation == 10)

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.lastInvocation == nil)
    }
}

// MARK: - Helpers

extension MockPropertySetterTests {
    private func sut() -> (
        setter: SUT,
        set: @Sendable (Value) -> Void,
        reset: @Sendable () -> Void
    ) {
        let setter = SUT()
        return (setter: setter, set: setter.set, reset: setter.reset)
    }
}
