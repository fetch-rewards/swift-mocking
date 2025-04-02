//
//  MockReturningParameterizedAsyncThrowingMethodTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import Foundation
import Testing
@testable import Mocked

struct MockReturningParameterizedAsyncThrowingMethodTests {

    // MARK: Typealiases

    typealias SUT = MockReturningParameterizedAsyncThrowingMethod<
        Implementation<Arguments, ReturnValue>
    >
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int
    typealias Closure = (String, Bool) async throws -> ReturnValue

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

        recordInput(("a", true))
        #expect(sut.callCount == 1)

        var returnValue = try await invoke("a", true)
        #expect(sut.callCount == 1)

        recordOutput(.success(returnValue))
        #expect(sut.callCount == 1)

        recordInput(("b", false))
        #expect(sut.callCount == 2)

        returnValue = try await invoke("b", false)
        #expect(sut.callCount == 2)

        recordOutput(.success(returnValue))
        #expect(sut.callCount == 2)

        reset()
        #expect(sut.callCount == .zero)
    }

    // MARK: Invocations Tests

    @Test
    func invocations() async throws {
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        let invoke = closure()
        #expect(sut.invocations.isEmpty)

        recordInput(("a", true))
        #expect(sut.invocations.count == 1)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)

        var returnValue = try await invoke("a", true)
        #expect(sut.invocations.count == 1)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)

        recordOutput(.success(returnValue))
        #expect(sut.invocations.count == 1)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)

        recordInput(("b", false))
        #expect(sut.invocations.count == 2)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)
        #expect(sut.invocations.last?.string == "b")
        #expect(sut.invocations.last?.boolean == false)

        returnValue = try await invoke("b", false)
        #expect(sut.invocations.count == 2)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)
        #expect(sut.invocations.last?.string == "b")
        #expect(sut.invocations.last?.boolean == false)

        recordOutput(.success(returnValue))
        #expect(sut.invocations.count == 2)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)
        #expect(sut.invocations.last?.string == "b")
        #expect(sut.invocations.last?.boolean == false)

        reset()
        #expect(sut.invocations.isEmpty)
    }

    // MARK: Last Invocation Tests

    @Test
    func lastInvocation() async throws {
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        let invoke = closure()
        #expect(sut.lastInvocation == nil)

        recordInput(("a", true))
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        var returnValue = try await invoke("a", true)
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        recordOutput(.success(returnValue))
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        recordInput(("b", false))
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        returnValue = try await invoke("b", false)
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        recordOutput(.success(returnValue))
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        reset()
        #expect(sut.lastInvocation == nil)
    }

    // MARK: Returned Values Tests

    @Test
    func returnedValues() async throws {
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        var invoke = closure()
        #expect(sut.returnedValues.isEmpty)

        recordInput(("a", true))
        #expect(sut.returnedValues.isEmpty)

        let returnValue = try await invoke("a", true)
        #expect(sut.returnedValues.isEmpty)

        recordOutput(.success(returnValue))
        #expect(try sut.returnedValues.last?.get() == 5)

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        invoke = closure()
        recordInput(("b", false))
        #expect(try sut.returnedValues.last?.get() == 5)

        do {
            _ = try await invoke("b", false)
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(try sut.returnedValues.last?.get() == 5)
            recordOutput(.failure(error))
        }

        #expect(throws: URLError(.badURL)) {
            try sut.returnedValues.last?.get()
        }

        reset()
        #expect(sut.returnedValues.isEmpty)
    }

    // MARK: Last Returned Value Tests

    @Test
    func lastReturnedValue() async throws {
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        var invoke = closure()
        #expect(sut.lastReturnedValue == nil)

        recordInput(("a", true))
        #expect(sut.lastReturnedValue == nil)

        let returnValue = try await invoke("a", true)
        #expect(sut.lastReturnedValue == nil)

        recordOutput(.success(returnValue))
        #expect(try sut.lastReturnedValue?.get() == 5)

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        invoke = closure()
        recordInput(("b", false))
        #expect(try sut.lastReturnedValue?.get() == 5)

        do {
            _ = try await invoke("b", false)
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(try sut.lastReturnedValue?.get() == 5)
            recordOutput(.failure(error))
        }

        #expect(throws: URLError(.badURL)) {
            try sut.lastReturnedValue?.get()
        }

        reset()
        #expect(sut.lastReturnedValue == nil)
    }
}

// MARK: - Implementation

extension MockReturningParameterizedAsyncThrowingMethodTests {
    enum Implementation<
        Arguments,
        ReturnValue
    >: @unchecked Sendable, MockReturningParameterizedAsyncThrowingMethodImplementation {
        typealias Closure = (String, Bool) async throws -> ReturnValue

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
        recordInput: (Arguments) -> Void,
        closure: () -> Closure,
        recordOutput: (Result<ReturnValue, any Error>) -> Void,
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
