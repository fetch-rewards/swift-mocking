//
//  MockedMacro_MacroErrorTests.swift
//  MockingMacrosTests
//
//  Created by Gray Campbell on 11/4/23.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedMacro_MacroErrorTests {

    // MARK: Typealiases

    typealias SUT = MockedMacro.MacroError

    // MARK: Description Tests

    @Test(arguments: SUT.allCases)
    func description(sut: SUT) {
        let expectedDescription = switch sut {
        case .canOnlyBeAppliedToProtocols:
            "@Mocked can only be applied to protocols."
        case .unableToParsePropertyBindingName:
            "@Mocked was unable to parse a property binding name."
        }

        #expect(sut.description == expectedDescription)
    }
}
#endif
