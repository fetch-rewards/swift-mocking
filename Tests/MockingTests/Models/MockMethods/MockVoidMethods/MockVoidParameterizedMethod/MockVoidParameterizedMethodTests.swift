//
//  MockVoidParameterizedMethodTests.swift
//
//  Created by Gray Campbell.
//  Copyright © 2025 Fetch.
//

import Testing
@testable import Mocking

struct MockVoidParameterizedMethodTests {

    // MARK: Typealiases

    typealias SUT = MockVoidParameterizedMethod<
        Implementation<Arguments>
    >
    typealias Arguments = (string: String, boolean: Bool)
    typealias Closure = (String, Bool) -> Void

    // MARK: Implementation Tests

    @Test
    func implementation() async {
        let (sut, _, closure, reset) = SUT.makeMethod()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }

        await confirmation(expectedCount: 1) { confirmation in
            sut.implementation = .uncheckedInvokes { _, _ in
                confirmation.confirm()
            }

            let invoke = closure()

            invoke?("a", true)
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
        let (sut, recordInput, closure, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in }

        let invoke = closure()
        #expect(sut.callCount == .zero)

        recordInput(("a", true))
        #expect(sut.callCount == 1)

        invoke?("a", true)
        #expect(sut.callCount == 1)

        recordInput(("b", false))
        #expect(sut.callCount == 2)

        invoke?("b", false)
        #expect(sut.callCount == 2)

        reset()
        #expect(sut.callCount == .zero)
    }

    // MARK: Invocations Tests

    @Test
    func invocations() {
        let (sut, recordInput, closure, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in }

        let invoke = closure()
        #expect(sut.invocations.isEmpty)

        recordInput(("a", true))
        #expect(sut.invocations.count == 1)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)

        invoke?("a", true)
        #expect(sut.invocations.count == 1)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)

        recordInput(("b", false))
        #expect(sut.invocations.count == 2)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)
        #expect(sut.invocations.last?.string == "b")
        #expect(sut.invocations.last?.boolean == false)

        invoke?("b", false)
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
    func lastInvocation() {
        let (sut, recordInput, closure, reset) = SUT.makeMethod()

        sut.implementation = .uncheckedInvokes { _, _ in }

        let invoke = closure()
        #expect(sut.lastInvocation == nil)

        recordInput(("a", true))
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        invoke?("a", true)
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        recordInput(("b", false))
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        invoke?("b", false)
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        reset()
        #expect(sut.lastInvocation == nil)
    }
}

// MARK: - Implementation

extension MockVoidParameterizedMethodTests {
    enum Implementation<
        Arguments
    >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {
        typealias Closure = (String, Bool) -> Void

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
