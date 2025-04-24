//
//  MethodOverloads.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A mock for verifying MockedMember's handling of method overloads.
///
/// - Important: Please only use this mock for permanent verification of
///   MockedMember's handling of method overloads. For temporary testing of
///   Mocked's expansion, use the `Playground` protocol in `main.swift`.
@MockedMembers
public final class MethodOverloadsMock {
    func decrement()
    func decrement() async

    func increment() async
    func increment() throws

    func increment(_ amount: Int)
    func increment(_ amount: Int) async
    func increment(_ amount: inout Int)
    func increment(_ amount: inout Int) async
    func increment(_ amount: consuming Int)
    func increment(_ amount: consuming Int) async

    func increment<Amount>(_ amount: Amount)
    func increment<Amount>(_ amount: Amount) async
    func increment<Amount>(_ amount: inout Amount)
    func increment<Amount>(_ amount: inout Amount) async
    func increment<Amount>(_ amount: sending Amount)
    func increment<Amount>(_ amount: sending Amount) async

    func increment<Amount: Numeric>(_ amount: Amount)
    func increment<Amount: Numeric>(_ amount: Amount) async
    func increment<Amount: Numeric>(_ amount: inout Amount)
    func increment<Amount: Numeric>(_ amount: inout Amount) async
    func increment<Amount: Numeric>(_ amount: sending Amount)
    func increment<Amount: Numeric>(_ amount: sending Amount) async

    func increment<Amount: Numeric>(_ amount: Amount) where Amount: Comparable
    func increment<Amount: Numeric>(_ amount: Amount) async where Amount: Comparable
    func increment<Amount: Numeric>(_ amount: inout Amount) where Amount: Comparable
    func increment<Amount: Numeric>(_ amount: inout Amount) async where Amount: Comparable
    func increment<Amount: Numeric>(_ amount: sending Amount) where Amount: Comparable
    func increment<Amount: Numeric>(_ amount: sending Amount) async where Amount: Comparable

    func increment(amount: Int) async
    func increment(amount: Int) throws
    func increment(amount: inout Int) async
    func increment(amount: inout Int) throws
    func increment(amount: consuming Int) async
    func increment(amount: consuming Int) throws

    func increment(by amount: Int)
    func increment(by amount: Int) async
    func increment(by amount: inout Int)
    func increment(by amount: inout Int) async
    func increment(by amount: consuming Int)
    func increment(by amount: consuming Int) async

    func increment(by amount: Int) async -> Int
    func increment(by amount: Int) throws -> Int
    func increment(by amount: inout Int) async -> Int
    func increment(by amount: inout Int) throws -> Int
    func increment(by amount: consuming Int) async -> Int
    func increment(by amount: consuming Int) throws -> Int

    func increment(using incrementor: Incrementor)
    func increment(using incrementor: Incrementor) async
    func increment(using incrementor: inout Incrementor)
    func increment(using incrementor: inout Incrementor) async
    func increment(using incrementor: sending Incrementor)
    func increment(using incrementor: sending Incrementor) async

    func increment<Incrementor: Identifiable>(using incrementor: Incrementor)
    func increment<Incrementor: Identifiable>(using incrementor: Incrementor) async
    func increment<Incrementor: Identifiable>(using incrementor: inout Incrementor)
    func increment<Incrementor: Identifiable>(using incrementor: inout Incrementor) async
    func increment<Incrementor: Identifiable>(using incrementor: sending Incrementor)
    func increment<Incrementor: Identifiable>(using incrementor: sending Incrementor) async

    func increment<Incrementor>(using incrementor: Incrementor) where Incrementor: Hashable
    func increment<Incrementor>(using incrementor: Incrementor) async where Incrementor: Hashable
    func increment<Incrementor>(using incrementor: inout Incrementor) where Incrementor: Hashable
    func increment<Incrementor>(
        using incrementor: inout Incrementor
    ) async where Incrementor: Hashable
    func increment<Incrementor>(using incrementor: sending Incrementor) where Incrementor: Hashable
    func increment<Incrementor>(
        using incrementor: sending Incrementor
    ) async where Incrementor: Hashable

    func increment(using incrementor: Incrementor) async -> Int
    func increment(using incrementor: Incrementor) throws -> Int
    func increment(using incrementor: inout Incrementor) async -> Int
    func increment(using incrementor: inout Incrementor) throws -> Int
    func increment(using incrementor: consuming Incrementor) async -> Int
    func increment(using incrementor: consuming Incrementor) throws -> Int

    func increment(using incrementor: @escaping () -> Incrementor)
    func increment(using incrementor: @escaping () -> Incrementor) async

    func increment(using incrementor: @escaping () -> Incrementor) async -> Int
    func increment(using incrementor: @escaping () -> Incrementor) throws -> Int

    func increment(using incrementor: @escaping (String) -> Incrementor)
    func increment(using incrementor: @escaping (String) -> Incrementor) async

    func increment(using incrementor: @escaping (String) -> Incrementor) async -> Int
    func increment(using incrementor: @escaping (String) -> Incrementor) throws -> Int
}

// MARK: - Incrementor

public struct Incrementor {}
