//
//  MockMemberNameComponentsTests.swift
//
//  Copyright © 2026 Fetch.
//

import SwiftParser
import SwiftSyntax
import Testing
@testable import MockingMacros

struct MockMemberNameComponentsTests {

    // MARK: Typealiases

    typealias SUT = MockMemberNameComponents

    // MARK: Method – Full Name Tests

    @Test
    func methodNoParamsNoReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() {}"))
        #expect(sut.fullName == "foo")
    }

    @Test
    func methodNoParamsWithReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() -> Int {}"))
        #expect(sut.fullName == "fooReturningInt")
    }

    @Test
    func methodOneParamNoReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) {}"))
        #expect(sut.fullName == "fooBarInt")
    }

    @Test
    func methodOneParamWithReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.fullName == "fooBarIntReturningString")
    }

    @Test
    func methodAsyncSpecifier() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() async {}"))
        #expect(sut.fullName == "fooAsync")
    }

    @Test
    func methodAsyncSpecifierWithReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() async -> Int {}"))
        #expect(sut.fullName == "fooReturningIntAsync")
    }

    @Test
    func methodThrowsSpecifierWithReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() throws -> Int {}"))
        #expect(sut.fullName == "fooReturningIntThrows")
    }

    @Test
    func methodAsyncThrowsSpecifiers() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() async throws -> Int {}"))
        #expect(sut.fullName == "fooReturningIntAsyncThrows")
    }

    @Test
    func methodParameterNameEqualsType() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(int: Int) {}"))
        #expect(sut.fullName == "fooInt")
    }

    @Test
    func methodTwoParamsWithReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(a: Int, b: String) -> Bool {}"))
        #expect(sut.fullName == "fooAIntBStringReturningBool")
    }

    @Test
    func methodVoidReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() -> Void {}"))
        #expect(sut.fullName == "foo")
    }

    @Test
    func methodEmptyTupleReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() -> () {}"))
        #expect(sut.fullName == "foo")
    }

    // MARK: Subscript – Full Name Tests

    @Test
    func subscriptOneParamWithReturn() {
        let sut = SUT(
            subscriptDeclaration: subscriptDecl(
                "subscript(key: String) -> Int { get {} }"
            )
        )
        #expect(sut.fullName == "subscriptKeyStringReturningInt")
    }

    @Test
    func subscriptTwoParamsWithReturn() {
        let sut = SUT(
            subscriptDeclaration: subscriptDecl(
                "subscript(row: Int, col: Int) -> String { get {} }"
            )
        )
        #expect(sut.fullName == "subscriptRowIntColIntReturningString")
    }

    // MARK: name(to:) Tests

    @Test
    func nameToZero() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: 0) == "foo")
    }

    @Test
    func nameToOne() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: 1) == "fooBar")
    }

    @Test
    func nameToTwo() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: 2) == "fooBarReturningString")
    }

    @Test
    func nameToLastIndex() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: 3) == sut.fullName)
    }

    @Test
    func nameToNegativeIndex() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: -1) == "foo")
    }

    @Test
    func nameToOutOfBoundsIndex() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: 100) == sut.fullName)
    }
}

// MARK: - Helpers

extension MockMemberNameComponentsTests {

    // MARK: SUT

    private func funcDecl(_ source: String) -> FunctionDeclSyntax {
        Parser.parse(source: source).statements.first!.item.as(FunctionDeclSyntax.self)!
    }

    private func subscriptDecl(_ source: String) -> SubscriptDeclSyntax {
        Parser.parse(source: source).statements.first!.item.as(SubscriptDeclSyntax.self)!
    }
}
