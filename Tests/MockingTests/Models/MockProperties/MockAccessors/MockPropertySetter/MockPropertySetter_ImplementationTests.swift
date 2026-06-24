//
//  MockPropertySetter_ImplementationTests.swift
//
//  Copyright © 2026 Fetch.
//

import Testing
@testable import Mocking

struct MockPropertySetter_ImplementationTests {

    // MARK: Typealiases

    typealias SUT = Setter.Implementation
    typealias Setter = MockPropertySetter<Value>
    typealias Value = Int

    // MARK: Call As Function Tests

    @Test
    func unimplemented() async {
        await confirmation(expectedCount: .zero) { _ in
            let sut: SUT = .unimplemented

            sut(5)
        }
    }

    @Test
    func uncheckedInvokes() async {
        await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .uncheckedInvokes { _ in
                confirmation.confirm()
            }

            sut(5)
        }
    }

    @Test
    func invokes() async {
        await confirmation(expectedCount: 1) { confirmation in
            let sut: SUT = .invokes { _ in
                confirmation.confirm()
            }

            sut(5)
        }
    }
}
