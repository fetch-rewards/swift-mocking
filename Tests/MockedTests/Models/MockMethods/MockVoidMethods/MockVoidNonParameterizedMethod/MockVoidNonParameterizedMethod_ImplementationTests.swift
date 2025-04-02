//
//  MockVoidNonParameterizedMethod_ImplementationTests.swift
//  MockedTests
//
//  Created by Gray Campbell on 3/18/25.
//

import Testing
@testable import Mocked

struct MockVoidNonParameterizedMethod_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Method.Implementation
    typealias Method = MockVoidNonParameterizedMethod

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async {
        await confirmation(expectedCount: .zero) { confirmation in
            let sut: SUT = .unimplemented

            sut()
        }
    }

    @Test
    func uncheckedInvokes() async {
        await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .uncheckedInvokes {
                confirmation.confirm()
            }

            sut()
        }
    }

    @Test
    func invokes() async {
        await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .invokes {
                confirmation.confirm()
            }

            sut()
        }
    }
}
