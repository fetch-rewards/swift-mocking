//
//  MockReturningParameterizedAsyncThrowingMethodTests.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockReturningParameterizedAsyncThrowingMethodTests {

    // MARK: Typealiases

    typealias SUT = MockReturningParameterizedAsyncThrowingMethod<
        Implementation<Arguments, ReturnValue>
    >
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int
    typealias Closure = @Sendable (String, Bool) async throws -> ReturnValue

    // MARK: Implementation Tests

    @Test
    func implementation() async throws {
        let (sut, _, closure, _, reset) = self.sut()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }

        try await confirmation(expectedCount: 1) { confirmation in
            sut.implementation = .uncheckedInvokes { _, _ in
                confirmation.confirm()
                return 5
            }

            let invoke = closure()

            _ = try await invoke("a", true)
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
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        let invoke = closure()
        #expect(sut.callCount == .zero)

        try await TestBarrier.executeConcurrently {
            recordInput(("a", true))
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount)

        try await TestBarrier.executeConcurrently {
            let returnValue = try await invoke("a", true)
            recordOutput(.success(returnValue))
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount)

        try await TestBarrier.executeConcurrently {
            recordInput(("b", false))
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount * 2)

        try await TestBarrier.executeConcurrently {
            let returnValue = try await invoke("b", false)
            recordOutput(.success(returnValue))
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
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        let invoke = closure()
        #expect(sut.invocations.isEmpty)

        try await TestBarrier.executeConcurrently {
            recordInput(("a", true))
        }
        #expect(sut.invocations.count == TestBarrier.defaultTaskCount)
        #expect(
            sut.invocations.allSatisfy { invocation in
                invocation == ("a", true)
            }
        )

        try await TestBarrier.executeConcurrently {
            let returnValue = try await invoke("a", true)
            recordOutput(.success(returnValue))
        }
        #expect(sut.invocations.count == TestBarrier.defaultTaskCount)
        #expect(
            sut.invocations.allSatisfy { invocation in
                invocation == ("a", true)
            }
        )

        try await TestBarrier.executeConcurrently {
            recordInput(("b", false))
        }
        #expect(sut.invocations.count == TestBarrier.defaultTaskCount * 2)
        #expect(
            sut.invocations.prefix(TestBarrier.defaultTaskCount).allSatisfy { invocation in
                invocation == ("a", true)
            }
        )
        #expect(
            sut.invocations.suffix(TestBarrier.defaultTaskCount).allSatisfy { invocation in
                invocation == ("b", false)
            }
        )

        try await TestBarrier.executeConcurrently {
            let returnValue = try await invoke("b", false)
            recordOutput(.success(returnValue))
        }
        #expect(sut.invocations.count == TestBarrier.defaultTaskCount * 2)
        #expect(
            sut.invocations.prefix(TestBarrier.defaultTaskCount).allSatisfy { invocation in
                invocation == ("a", true)
            }
        )
        #expect(
            sut.invocations.suffix(TestBarrier.defaultTaskCount).allSatisfy { invocation in
                invocation == ("b", false)
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
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        let invoke = closure()
        #expect(sut.lastInvocation == nil)

        try await TestBarrier.executeConcurrently {
            recordInput(("a", true))
        }
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        try await TestBarrier.executeConcurrently {
            let returnValue = try await invoke("a", true)
            recordOutput(.success(returnValue))
        }
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        try await TestBarrier.executeConcurrently {
            recordInput(("b", false))
        }
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        try await TestBarrier.executeConcurrently {
            let returnValue = try await invoke("b", false)
            recordOutput(.success(returnValue))
        }
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.lastInvocation == nil)
    }

    // MARK: Returned Values Tests

    @Test
    func returnedValues() async throws {
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        let invoke1 = closure()
        #expect(sut.returnedValues.isEmpty)

        try await TestBarrier.executeConcurrently {
            recordInput(("a", true))
        }
        #expect(sut.returnedValues.isEmpty)

        try await TestBarrier.executeConcurrently {
            let returnValue = try await invoke1("a", true)
            recordOutput(.success(returnValue))
        }
        #expect(sut.returnedValues.count == TestBarrier.defaultTaskCount)
        #expect(
            sut.returnedValues.allSatisfy { returnedValue in
                (try? returnedValue.get()) == 5
            }
        )

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        let invoke2 = closure()
        try await TestBarrier.executeConcurrently {
            recordInput(("b", false))
        }
        #expect(sut.returnedValues.count == TestBarrier.defaultTaskCount)
        #expect(
            sut.returnedValues.allSatisfy { returnedValue in
                (try? returnedValue.get()) == 5
            }
        )

        do {
            try await TestBarrier.executeConcurrently {
                _ = try await invoke2("b", false)
            }
            Issue.record("Expected invoke to throw error.")
        } catch {
            try await TestBarrier.executeConcurrently {
                recordOutput(.failure(error))
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
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        let invoke1 = closure()
        #expect(sut.lastReturnedValue == nil)

        try await TestBarrier.executeConcurrently {
            recordInput(("a", true))
        }
        #expect(sut.lastReturnedValue == nil)

        try await TestBarrier.executeConcurrently {
            let returnValue = try await invoke1("a", true)
            recordOutput(.success(returnValue))
        }
        #expect(try sut.lastReturnedValue?.get() == 5)

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        let invoke2 = closure()
        try await TestBarrier.executeConcurrently {
            recordInput(("b", false))
        }
        #expect(try sut.lastReturnedValue?.get() == 5)

        do {
            try await TestBarrier.executeConcurrently {
                _ = try await invoke2("b", false)
            }
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(try sut.lastReturnedValue?.get() == 5)
            try await TestBarrier.executeConcurrently {
                recordOutput(.failure(error))
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

// MARK: - Implementation

extension MockReturningParameterizedAsyncThrowingMethodTests {
    enum Implementation<
        Arguments,
        ReturnValue
    >: @unchecked Sendable, MockReturningParameterizedAsyncThrowingMethodImplementation {
        typealias Closure = @Sendable (String, Bool) async throws -> ReturnValue

        case unimplemented
        case uncheckedInvokes(_ closure: Closure)

        var _closure: Closure? {
            switch self {
            case .unimplemented:
                nil
            case let .uncheckedInvokes(closure):
                closure
            }
        }
    }
}

// MARK: - Helpers

extension MockReturningParameterizedAsyncThrowingMethodTests {
    private func sut() -> (
        method: SUT,
        recordInput: @Sendable (Arguments) -> Void,
        closure: @Sendable () -> Closure,
        recordOutput: @Sendable (Result<ReturnValue, any Error>) -> Void,
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
