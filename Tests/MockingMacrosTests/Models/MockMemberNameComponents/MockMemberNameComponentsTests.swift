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

    @Test("Returns the method name alone for a method with no parameters or return type.")
    func methodNoParamsNoReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() {}"))
        #expect(sut.fullName == "foo")
    }

    @Test("Includes the return type for a method with no parameters.")
    func methodNoParamsWithReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() -> Int {}"))
        #expect(sut.fullName == "fooReturningInt")
    }

    @Test("Includes the parameter name and type for a method with one parameter and no return type.")
    func methodOneParamNoReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) {}"))
        #expect(sut.fullName == "fooBarInt")
    }

    @Test("Includes the parameter type interleaved before the return type for a method with one parameter.")
    func methodOneParamWithReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.fullName == "fooBarIntReturningString")
    }

    @Test("Appends 'Async' for a method with an async specifier and no return type.")
    func methodAsyncSpecifier() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() async {}"))
        #expect(sut.fullName == "fooAsync")
    }

    @Test("Appends 'Async' after the return type for a method with an async specifier.")
    func methodAsyncSpecifierWithReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() async -> Int {}"))
        #expect(sut.fullName == "fooReturningIntAsync")
    }

    @Test("Appends 'Throws' after the return type for a method with a throws specifier.")
    func methodThrowsSpecifierWithReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() throws -> Int {}"))
        #expect(sut.fullName == "fooReturningIntThrows")
    }

    @Test("Appends 'Async' then 'Throws' for a method with both effect specifiers.")
    func methodAsyncThrowsSpecifiers() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() async throws -> Int {}"))
        #expect(sut.fullName == "fooReturningIntAsyncThrows")
    }

    @Test("Omits the parameter type component when it is identical to the parameter name.")
    func methodParameterNameEqualsType() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(int: Int) {}"))
        #expect(sut.fullName == "fooInt")
    }

    @Test("Interleaves parameter types between parameter names for a method with two parameters.")
    func methodTwoParamsWithReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(a: Int, b: String) -> Bool {}"))
        #expect(sut.fullName == "fooAIntBStringReturningBool")
    }

    @Test("Treats an explicit Void return type the same as no return type.")
    func methodVoidReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() -> Void {}"))
        #expect(sut.fullName == "foo")
    }

    @Test("Treats an empty tuple return type the same as no return type.")
    func methodEmptyTupleReturn() {
        let sut = SUT(methodDeclaration: funcDecl("func foo() -> () {}"))
        #expect(sut.fullName == "foo")
    }

    // MARK: Subscript – Full Name Tests

    @Test("Produces the subscript keyword, parameter name, parameter type, and return type for a single-parameter subscript.")
    func subscriptOneParamWithReturn() {
        let sut = SUT(subscriptDeclaration: subscriptDecl("subscript(key: String) -> Int { get {} }"))
        #expect(sut.fullName == "subscriptKeyStringReturningInt")
    }

    @Test("Interleaves parameter types between parameter names for a multi-parameter subscript.")
    func subscriptTwoParamsWithReturn() {
        let sut = SUT(subscriptDeclaration: subscriptDecl("subscript(row: Int, col: Int) -> String { get {} }"))
        #expect(sut.fullName == "subscriptRowIntColIntReturningString")
    }

    // MARK: name(to:) Tests

    @Test("Returns only the method name when stopping at component index 0.")
    func nameToZero() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: 0) == "foo")
    }

    @Test("Returns the method name and parameter name when stopping at component index 1.")
    func nameToOne() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: 1) == "fooBar")
    }

    @Test("Returns the method name, parameter name, and return type when stopping at component index 2.")
    func nameToTwo() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: 2) == "fooBarReturningString")
    }

    @Test("Returns the full name when stopping at the last component index.")
    func nameToLastIndex() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: 3) == sut.fullName)
    }

    @Test("Clamps a negative index to zero, returning only the method name.")
    func nameToNegativeIndex() {
        let sut = SUT(methodDeclaration: funcDecl("func foo(bar: Int) -> String {}"))
        #expect(sut.name(to: -1) == "foo")
    }

    @Test("Clamps an out-of-bounds index to the last component, returning the full name.")
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
