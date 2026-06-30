//
//  MockedSubscriptMacro_MacroErrorTests.swift
//
//  Copyright © 2026 Fetch.
//

#if canImport(MockingMacros)
import Testing
@testable import MockingMacros

struct MockedSubscriptMacro_MacroErrorTests {

    // MARK: Typealiases

    typealias SUT = MockedSubscriptMacro.MacroError

    // MARK: Description Tests

    @Test(arguments: SUT.allCases)
    func description(sut: SUT) {
        let expectedDescription = switch sut {
        case .canOnlyBeAppliedToSubscriptDeclarations:
            "@_MockedSubscript can only be applied to subscript declarations."
        case .noArguments:
            "@_MockedSubscript was not passed any arguments."
        case .unableToParseSubscriptTypeArgument:
            "@_MockedSubscript was unable to parse the provided `subscriptType` argument."
        case .unableToParseMockNameArgument:
            "@_MockedSubscript was unable to parse the provided `mockName` argument."
        case .unableToParseIsMockAnActorArgument:
            "@_MockedSubscript was unable to parse the provided `isMockAnActor` argument."
        case .unableToParseMockSubscriptNameArgument:
            "@_MockedSubscript was unable to parse the provided `mockSubscriptName` argument."
        }

        #expect(sut.description == expectedDescription)
    }
}
#endif
