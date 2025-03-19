//
//  MockReturningParameterizedAsyncMethodTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 12/7/23.
//

import Testing
@testable import Mocked

struct MockReturningParameterizedAsyncMethodTests {

    // MARK: Typealiases

    typealias SUT = MockReturningParameterizedAsyncMethod<
        Implementation<Arguments, ReturnValue>
    >
    typealias Arguments = (string: String, boolean: Bool)
    typealias ReturnValue = Int
    typealias Closure = (String, Bool) async -> ReturnValue

    // MARK: Implementation Tests

    @Test
    func implementation() async {
        let (sut, _, closure, _, reset) = self.sut()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }

        await confirmation(expectedCount: 1) { confirmation in
            sut.implementation = .uncheckedInvokes { _, _ in
                confirmation.confirm()
                return 5
            }

            let invoke = closure()

            _ = await invoke("a", true)
        }

        reset()

        guard case .unimplemented = sut.implementation else {
            Issue.record("Expected implementation to equal .unimplemented")
            return
        }
    }

    // MARK: Call Count Tests

    @Test
    func callCount() async {
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        let invoke = closure()
        #expect(sut.callCount == .zero)

        recordInput(("a", true))
        #expect(sut.callCount == 1)

        var returnValue = await invoke("a", true)
        #expect(sut.callCount == 1)

        recordOutput(returnValue)
        #expect(sut.callCount == 1)

        recordInput(("b", false))
        #expect(sut.callCount == 2)

        returnValue = await invoke("b", false)
        #expect(sut.callCount == 2)

        recordOutput(returnValue)
        #expect(sut.callCount == 2)

        reset()
        #expect(sut.callCount == .zero)
    }

    // MARK: Invocations Tests

    @Test
    func invocations() async {
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        let invoke = closure()
        #expect(sut.invocations.isEmpty)

        recordInput(("a", true))
        #expect(sut.invocations.count == 1)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)

        var returnValue = await invoke("a", true)
        #expect(sut.invocations.count == 1)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)

        recordOutput(returnValue)
        #expect(sut.invocations.count == 1)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)

        recordInput(("b", false))
        #expect(sut.invocations.count == 2)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)
        #expect(sut.invocations.last?.string == "b")
        #expect(sut.invocations.last?.boolean == false)

        returnValue = await invoke("b", false)
        #expect(sut.invocations.count == 2)
        #expect(sut.invocations.first?.string == "a")
        #expect(sut.invocations.first?.boolean == true)
        #expect(sut.invocations.last?.string == "b")
        #expect(sut.invocations.last?.boolean == false)

        recordOutput(returnValue)
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
    func lastInvocation() async {
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        let invoke = closure()
        #expect(sut.lastInvocation == nil)

        recordInput(("a", true))
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        var returnValue = await invoke("a", true)
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        recordOutput(returnValue)
        #expect(sut.lastInvocation?.string == "a")
        #expect(sut.lastInvocation?.boolean == true)

        recordInput(("b", false))
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        returnValue = await invoke("b", false)
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        recordOutput(returnValue)
        #expect(sut.lastInvocation?.string == "b")
        #expect(sut.lastInvocation?.boolean == false)

        reset()
        #expect(sut.lastInvocation == nil)
    }

    // MARK: Returned Values Tests

    @Test
    func returnedValues() async {
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        var invoke = closure()
        #expect(sut.returnedValues.isEmpty)

        recordInput(("a", true))
        #expect(sut.returnedValues.isEmpty)

        var returnValue = await invoke("a", true)
        #expect(sut.returnedValues.isEmpty)

        recordOutput(returnValue)
        #expect(sut.returnedValues == [5])

        sut.implementation = .uncheckedInvokes { _, _ in 10 }

        invoke = closure()
        recordInput(("b", false))
        #expect(sut.returnedValues == [5])

        returnValue = await invoke("b", false)
        #expect(sut.returnedValues == [5])

        recordOutput(returnValue)
        #expect(sut.returnedValues == [5, 10])

        reset()
        #expect(sut.returnedValues.isEmpty)
    }

    // MARK: Last Returned Value Tests

    @Test
    func lastReturnedValue() async {
        let (sut, recordInput, closure, recordOutput, reset) = self.sut()

        sut.implementation = .uncheckedInvokes { _, _ in 5 }

        var invoke = closure()
        #expect(sut.lastReturnedValue == nil)

        recordInput(("a", true))
        #expect(sut.lastReturnedValue == nil)

        var returnValue = await invoke("a", true)
        #expect(sut.lastReturnedValue == nil)

        recordOutput(returnValue)
        #expect(sut.lastReturnedValue == 5)

        sut.implementation = .uncheckedInvokes { _, _ in 10 }

        invoke = closure()
        recordInput(("b", false))
        #expect(sut.lastReturnedValue == 5)

        returnValue = await invoke("b", false)
        #expect(sut.lastReturnedValue == 5)

        recordOutput(returnValue)
        #expect(sut.lastReturnedValue == 10)

        reset()
        #expect(sut.lastReturnedValue == nil)
    }
}

// MARK: - Implementation

extension MockReturningParameterizedAsyncMethodTests {
    enum Implementation<
        Arguments,
        ReturnValue
    >: @unchecked Sendable, MockReturningParameterizedAsyncMethodImplementation {
        typealias Closure = (String, Bool) async -> ReturnValue

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

extension MockReturningParameterizedAsyncMethodTests {
    private func sut() -> (
        method: SUT,
        recordInput: (Arguments) -> Void,
        closure: () -> Closure,
        recordOutput: (ReturnValue) -> Void,
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
