//
//  MockVoidParameterizedThrowingMethodTests.swift
//  MockingTests
//
//  Created by Gray Campbell on 12/8/23.
//

import Foundation
import Testing
@testable import Mocking

struct MockVoidParameterizedThrowingMethodTests {

    // MARK: Typealiases

    typealias SUT = MockVoidParameterizedThrowingMethod<
        Implementation<Arguments>
    >
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int
    typealias Closure = (String, Bool) throws -> Void

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

            try invoke?("a", true)
        }

        reset()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    @Test
    func callCount() throws {
        let (sut, recordInput, closure, recordOutput, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        let invoke = closure()
        #expect(sut.callCount == .zero)

        recordInput(("a", true))
        #expect(sut.callCount == 1)

        do {
            try invoke?("a", true)
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.callCount == 1)

            recordOutput(error)
            #expect(sut.callCount == 1)
        }

        recordInput(("b", false))
        #expect(sut.callCount == 2)

        do {
            try invoke?("b", false)
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.callCount == 2)

            recordOutput(error)
            #expect(sut.callCount == 2)
        }

        reset()
        #expect(sut.callCount == .zero)
    }

    // MARK: Invocations Tests

    @Test
    func invocations() throws {
        let (sut, recordInput, closure, recordOutput, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        let invoke = closure()
        #expect(sut.invocations.isEmpty)

        recordInput(("a", true))
        #expect(sut.invocations.count == 1)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)

        do {
            try invoke?("a", true)
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.invocations.count == 1)
            #expect(sut.invocations.first?.string == "a")
            #expect(sut.invocations.first?.boolean == true)

            recordOutput(error)
            #expect(sut.invocations.count == 1)
            #expect(sut.invocations.first?.string == "a")
            #expect(sut.invocations.first?.boolean == true)
        }

        recordInput(("b", false))
        #expect(sut.invocations.count == 2)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)
        #expect(sut.invocations.last?.string == "b")
        #expect(sut.invocations.last?.boolean == false)

        do {
            try invoke?("b", false)
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.invocations.count == 2)
            #expect(sut.invocations.first?.string == "a")
            #expect(sut.invocations.first?.boolean == true)
            #expect(sut.invocations.last?.string == "b")
            #expect(sut.invocations.last?.boolean == false)

            recordOutput(error)
            #expect(sut.invocations.count == 2)
            #expect(sut.invocations.first?.string == "a")
            #expect(sut.invocations.first?.boolean == true)
            #expect(sut.invocations.last?.string == "b")
            #expect(sut.invocations.last?.boolean == false)
        }

        reset()
        #expect(sut.invocations.isEmpty)
    }

    // MARK: Last Invocation Tests

    @Test
    func lastInvocation() throws {
        let (sut, recordInput, closure, recordOutput, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        let invoke = closure()
        #expect(sut.lastInvocation == nil)

        recordInput(("a", true))
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        do {
            try invoke?("a", true)
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.lastInvocation?.string == "a")
            #expect(sut.lastInvocation?.boolean == true)

            recordOutput(error)
            #expect(sut.lastInvocation?.string == "a")
            #expect(sut.lastInvocation?.boolean == true)
        }

        recordInput(("b", false))
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        do {
            try invoke?("b", false)
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.lastInvocation?.string == "b")
            #expect(sut.lastInvocation?.boolean == false)

            recordOutput(error)
            #expect(sut.lastInvocation?.string == "b")
            #expect(sut.lastInvocation?.boolean == false)
        }

        reset()
        #expect(sut.lastInvocation == nil)
    }

    // MARK: Thrown Errors Tests

    @Test
    func thrownErrors() throws {
        let (sut, recordInput, closure, recordOutput, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in }

        var invoke = closure()
        #expect(sut.thrownErrors.isEmpty)

        recordInput(("a", true))
        #expect(sut.thrownErrors.isEmpty)

        try invoke?("a", true)
        #expect(sut.thrownErrors.isEmpty)

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        invoke = closure()
        recordInput(("b", false))
        #expect(sut.thrownErrors.isEmpty)

        do {
            try invoke?("b", false)
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.thrownErrors.isEmpty)

            recordOutput(error)

            let lastThrownError = try #require(sut.thrownErrors.last)

            #expect(throws: URLError(.badURL)) {
                throw lastThrownError
            }
        }

        reset()
        #expect(sut.thrownErrors.isEmpty)
    }

    // MARK: Last Thrown Error Tests

    @Test
    func lastThrownError() throws {
        let (sut, recordInput, closure, recordOutput, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in }

        var invoke = closure()
        #expect(sut.lastThrownError == nil)

        recordInput(("a", true))
        #expect(sut.lastThrownError == nil)

        try invoke?("a", true)
        #expect(sut.lastThrownError == nil)

        sut.implementation = .uncheckedInvokes { _, _ in
            throw URLError(.badURL)
        }

        invoke = closure()
        recordInput(("b", false))
        #expect(sut.lastThrownError == nil)

        do {
            try invoke?("b", false)
            Issue.record("Expected invoke to throw error.")
        } catch {
            #expect(sut.lastThrownError == nil)

            recordOutput(error)

            let lastThrownError = try #require(sut.lastThrownError)

            #expect(throws: URLError(.badURL)) {
                throw lastThrownError
            }
        }

        reset()
        #expect(sut.lastThrownError == nil)
    }
}

// MARK: - Implementation

extension MockVoidParameterizedThrowingMethodTests {
    enum Implementation<
        Arguments
    >: @unchecked Sendable, MockVoidParameterizedThrowingMethodImplementation {
        typealias Closure = (String, Bool) throws -> Void

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
