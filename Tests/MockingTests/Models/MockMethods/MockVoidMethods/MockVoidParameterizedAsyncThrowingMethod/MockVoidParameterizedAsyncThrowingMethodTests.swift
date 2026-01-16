//
//  MockVoidParameterizedAsyncThrowingMethodTests.swift
//
//  Copyright © 2026 Fetch.
//

import Foundation
import Testing
@testable import Mocking

struct MockVoidParameterizedAsyncThrowingMethodTests {

    // MARK: Typealiases

    typealias SUT = MockVoidParameterizedAsyncThrowingMethod<
        Implementation<Arguments>
    >
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int
    typealias Closure = (String, Bool) async throws -> Void

    // MARK: Implementation Tests

    @Test
    func implementation() async throws {
        let (sut, _, closure, _, reset) = SUT.makeMethod()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }

        try await confirmation(expectedCount: 1) { confirmation in
            sut.implementation = .uncheckedInvokes { _, _ in
                confirmation.confirm()
            }

            let invoke = closure()

            try await invoke?("a", true)
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
        let (sut, recordInput, closure, recordOutput, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        let invoke = closure()
        #expect(sut.callCount == .zero)

        try await TestBarrier.executeConcurrently {
            recordInput(("a", true))
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount)

        do {
            try await TestBarrier.executeConcurrently {
                try await invoke?("a", true)
            }
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.callCount == TestBarrier.defaultTaskCount)

            try await TestBarrier.executeConcurrently {
                recordOutput(error)
            }
            #expect(sut.callCount == TestBarrier.defaultTaskCount)
        }

        try await TestBarrier.executeConcurrently {
            recordInput(("b", false))
        }
        #expect(sut.callCount == TestBarrier.defaultTaskCount * 2)

        do {
            try await TestBarrier.executeConcurrently {
                try await invoke?("b", false)
            }
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.callCount == TestBarrier.defaultTaskCount * 2)

            try await TestBarrier.executeConcurrently {
                recordOutput(error)
            }
            #expect(sut.callCount == TestBarrier.defaultTaskCount * 2)
        }

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.callCount == .zero)
    }

    // MARK: Invocations Tests

    @Test
    func invocations() async throws {
        let (sut, recordInput, closure, recordOutput, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        let invoke = closure()
        #expect(sut.invocations.isEmpty)

        try await TestBarrier.executeConcurrently {
            recordInput(("a", true))
        }
        #expect(sut.invocations.count == TestBarrier.defaultTaskCount)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)

        do {
            try await TestBarrier.executeConcurrently {
                try await invoke?("a", true)
            }
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.invocations.count == TestBarrier.defaultTaskCount)
            #expect(sut.invocations.first?.string == "a")
            #expect(sut.invocations.first?.boolean == true)

            try await TestBarrier.executeConcurrently {
                recordOutput(error)
            }
            #expect(sut.invocations.count == TestBarrier.defaultTaskCount)
            #expect(sut.invocations.first?.string == "a")
            #expect(sut.invocations.first?.boolean == true)
        }

        try await TestBarrier.executeConcurrently {
            recordInput(("b", false))
        }
        #expect(sut.invocations.count == TestBarrier.defaultTaskCount * 2)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)
        #expect(sut.invocations.last?.string == "b")
        #expect(sut.invocations.last?.boolean == false)

        do {
            try await TestBarrier.executeConcurrently {
                try await invoke?("b", false)
            }
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.invocations.count == TestBarrier.defaultTaskCount * 2)
            #expect(sut.invocations.first?.string == "a")
            #expect(sut.invocations.first?.boolean == true)
            #expect(sut.invocations.last?.string == "b")
            #expect(sut.invocations.last?.boolean == false)

            try await TestBarrier.executeConcurrently {
                recordOutput(error)
            }
            #expect(sut.invocations.count == TestBarrier.defaultTaskCount * 2)
            #expect(sut.invocations.first?.string == "a")
            #expect(sut.invocations.first?.boolean == true)
            #expect(sut.invocations.last?.string == "b")
            #expect(sut.invocations.last?.boolean == false)
        }

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.invocations.isEmpty)
    }

    // MARK: Last Invocation Tests

    @Test
    func lastInvocation() async throws {
        let (sut, recordInput, closure, recordOutput, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        let invoke = closure()
        #expect(sut.lastInvocation == nil)

        try await TestBarrier.executeConcurrently {
            recordInput(("a", true))
        }
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        do {
            try await TestBarrier.executeConcurrently {
                try await invoke?("a", true)
            }
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.lastInvocation?.string == "a")
            #expect(sut.lastInvocation?.boolean == true)

            try await TestBarrier.executeConcurrently {
                recordOutput(error)
            }
            #expect(sut.lastInvocation?.string == "a")
            #expect(sut.lastInvocation?.boolean == true)
        }

        try await TestBarrier.executeConcurrently {
            recordInput(("b", false))
        }
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        do {
            try await TestBarrier.executeConcurrently {
                try await invoke?("b", false)
            }
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.lastInvocation?.string == "b")
            #expect(sut.lastInvocation?.boolean == false)

            try await TestBarrier.executeConcurrently {
                recordOutput(error)
            }
            #expect(sut.lastInvocation?.string == "b")
            #expect(sut.lastInvocation?.boolean == false)
        }

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.lastInvocation == nil)
    }

    // MARK: Thrown Errors Tests

    @Test
    func thrownErrors() async throws {
        let (sut, recordInput, closure, recordOutput, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in }

        let invoke1 = closure()
        #expect(sut.thrownErrors.isEmpty)

        try await TestBarrier.executeConcurrently {
            recordInput(("a", true))
        }
        #expect(sut.thrownErrors.isEmpty)

        try await TestBarrier.executeConcurrently {
            try await invoke1?("a", true)
        }
        #expect(sut.thrownErrors.isEmpty)

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        let invoke2 = closure()
        try await TestBarrier.executeConcurrently {
            recordInput(("b", false))
        }
        #expect(sut.thrownErrors.isEmpty)

        do {
            try await TestBarrier.executeConcurrently {
                try await invoke2?("b", false)
            }
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.thrownErrors.isEmpty)

            try await TestBarrier.executeConcurrently {
                recordOutput(error)
            }

            let lastThrownError = try #require(sut.thrownErrors.last)

            #expect(throws: URLError(.badURL)) {
                throw lastThrownError
            }
        }

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.thrownErrors.isEmpty)
    }

    // MARK: Last Thrown Error Tests

    @Test
    func lastThrownError() async throws {
        let (sut, recordInput, closure, recordOutput, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in }

        let invoke1 = closure()
        #expect(sut.lastThrownError == nil)

        try await TestBarrier.executeConcurrently {
            recordInput(("a", true))
        }
        #expect(sut.lastThrownError == nil)

        try await TestBarrier.executeConcurrently {
            try await invoke1?("a", true)
        }
        #expect(sut.lastThrownError == nil)

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        let invoke2 = closure()
        try await TestBarrier.executeConcurrently {
            recordInput(("b", false))
        }
        #expect(sut.lastThrownError == nil)

        do {
            try await TestBarrier.executeConcurrently {
                try await invoke2?("b", false)
            }
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.lastThrownError == nil)

            try await TestBarrier.executeConcurrently {
                recordOutput(error)
            }

            let lastThrownError = try #require(sut.lastThrownError)

            #expect(throws: URLError(.badURL)) {
                throw lastThrownError
            }
        }

        try await TestBarrier.executeConcurrently {
            reset()
        }
        #expect(sut.lastThrownError == nil)
    }
}

// MARK: - Implementation

extension MockVoidParameterizedAsyncThrowingMethodTests {
    enum Implementation<
        Arguments
    >: @unchecked Sendable, MockVoidParameterizedAsyncThrowingMethodImplementation {
        typealias Closure = @Sendable (String, Bool) async throws -> Void

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
