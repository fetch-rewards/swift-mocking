//
//  MockSubscriptThrowingGetterTests.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockSubscriptThrowingGetterTests {

    // MARK: Typealiases

    typealias SUT = MockSubscriptThrowingGetter<Arguments, Value>
    typealias Arguments = String
    typealias Value = Int

    // MARK: Implementation Tests

    @Test
    func implementation() async throws {
        let (sut, get, reset) = self.sut()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }

        try await confirmation(expectedCount: 1) { confirmation in
            sut.implementation = .uncheckedInvokes { _ in
                confirmation.confirm()
                return 5
            }

            _ = try get("a")
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
        let (sut, get, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _ in 5 }

        #expect(sut.callCount == .zero)

        try await TestBarrier.executeConcurrently {
            _ = try get("a")
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount)

        sut.implementation = .uncheckedInvokes { _ in throw URLError(.badURL) }

        await #expect(throws: URLError(.badURL)) {
            try await TestBarrier.executeConcurrently {
                _ = try get("b")
            }
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount * 2)

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.callCount == .zero)
    }

    // MARK: Invocations Tests

    @Test
    func invocations() async throws {
        let (sut, get, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _ in 5 }

        #expect(sut.invocations.isEmpty)

        try await TestBarrier.executeConcurrently {
            _ = try get("a")
        }
        #expect(sut.invocations.count == TestBarrier.defaultTaskCount)
        #expect(
            sut.invocations.allSatisfy { invocation in
                invocation == "a"
            }
        )

        try await TestBarrier.executeConcurrently {
            _ = try get("b")
        }
        #expect(sut.invocations.count == TestBarrier.defaultTaskCount * 2)
        #expect(
            sut.invocations.prefix(TestBarrier.defaultTaskCount).allSatisfy { invocation in
                invocation == "a"
            }
        )
        #expect(
            sut.invocations.suffix(TestBarrier.defaultTaskCount).allSatisfy { invocation in
                invocation == "b"
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
        let (sut, get, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _ in 5 }

        #expect(sut.lastInvocation == nil)

        try await TestBarrier.executeConcurrently {
            _ = try get("a")
        }
        #expect(sut.lastInvocation == "a")

        try await TestBarrier.executeConcurrently {
            _ = try get("b")
        }
        #expect(sut.lastInvocation == "b")

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.lastInvocation == nil)
    }

    // MARK: Returned Values Tests

    @Test
    func returnedValues() async throws {
        let (sut, get, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _ in 5 }

        #expect(sut.returnedValues.isEmpty)

        try await TestBarrier.executeConcurrently {
            _ = try get("a")
        }
        #expect(sut.returnedValues.count == TestBarrier.defaultTaskCount)
        #expect(
            sut.returnedValues.allSatisfy { returnedValue in
                (try? returnedValue.get()) == 5
            }
        )

        sut.implementation = .uncheckedInvokes { _ in throw URLError(.badURL) }

        await #expect(throws: URLError(.badURL)) {
            try await TestBarrier.executeConcurrently {
                _ = try get("b")
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
        let (sut, get, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _ in 5 }

        #expect(sut.lastReturnedValue == nil)

        try await TestBarrier.executeConcurrently {
            _ = try get("a")
        }
        #expect(try sut.lastReturnedValue?.get() == 5)

        sut.implementation = .uncheckedInvokes { _ in throw URLError(.badURL) }

        await #expect(throws: URLError(.badURL)) {
            try await TestBarrier.executeConcurrently {
                _ = try get("b")
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

extension MockSubscriptThrowingGetterTests {
    private func sut() -> (
        getter: SUT,
        get: @Sendable (Arguments) throws -> Value,
        reset: @Sendable () -> Void
    ) {
        let getter = SUT(
            exposedSubscriptDescription: MockImplementationDescription(
                type: Self.self,
                member: "sut"
            )
        )
        return (getter: getter, get: getter.get, reset: getter.reset)
    }
}
