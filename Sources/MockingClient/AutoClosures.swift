//
//  AutoClosures.swift
//
//  Copyright © 2025 Fetch.
//

import Foundation
public import Mocking

/// A protocol for verifying Mocked's handling of autoclosures.
///
/// - Important: Please only use this protocol for permanent verification of
///   Mocked's handling of autoclosures. For temporary testing of Mocked's
///   expansion, use the `Playground` protocol in `main.swift`.
//@Mocked(compilationCondition: .none)
public protocol AutoClosures {
//    func methodWithVoidAutoClosure(autoClosure: @escaping @autoclosure () -> Void)
    func methodWithNonVoidAutoClosure(autoClosure: @escaping @autoclosure () async -> Int)
//    func methodWithConsumingVoidAutoClosure(autoClosure: consuming @escaping @autoclosure () -> Void)
//    func methodWithConsumingNonVoidAutoClosure(autoClosure: consuming @escaping @autoclosure () -> Int)
}

@MockedMembers
public final class AutoClosuresMock: AutoClosures {
//    public func methodWithVoidAutoClosure(autoClosure: @escaping @autoclosure () -> Void)
    public func methodWithNonVoidAutoClosure(autoClosure: @escaping @autoclosure () async -> Int)
//    public func methodWithConsumingVoidAutoClosure(autoClosure: consuming @escaping @autoclosure () -> Void)
//    public func methodWithConsumingNonVoidAutoClosure(autoClosure: consuming @escaping @autoclosure () -> Int)
}

//@MockedMembers
//public final class AutoClosuresMock: AutoClosures {
//    public init() {
//    }
//    /// An implementation for `AutoClosuresMock._methodWithAutoClosure`.
//    public enum MethodWithAutoClosureImplementation<
//        Arguments
//    >: @unchecked Sendable, MockVoidParameterizedMethodImplementation {
//
//        /// The implementation's closure type.
//        public typealias Closure = (Int) -> Void
//
//        /// Does nothing when invoked.
//        case unimplemented
//
//        /// Invokes the provided closure when invoked.
//        ///
//        /// - Parameter closure: The closure to invoke.
//        case uncheckedInvokes(_ closure: Closure)
//
//        /// Invokes the provided closure when invoked.
//        ///
//        /// - Parameter closure: The closure to invoke.
//        public static func invokes(
//            _ closure: @Sendable @escaping (Int) -> Void
//        ) -> Self where Arguments: Sendable {
//            .uncheckedInvokes(closure)
//        }
//
//        /// The implementation as a closure, or `nil` if unimplemented.
//        public var _closure: Closure? {
//            switch self {
//            case .unimplemented:
//                nil
//            case let .uncheckedInvokes(closure):
//                closure
//            }
//        }
//    }
//
//    private let __methodWithAutoClosure = MockVoidParameterizedMethod<
//        MethodWithAutoClosureImplementation<
//            (Int)
//        >
//    >.makeMethod()
//
//    public var _methodWithAutoClosure: MockVoidParameterizedMethod<
//        MethodWithAutoClosureImplementation<
//            (Int)
//        >
//    > {
//        self.__methodWithAutoClosure.method
//    }
//
//    public func methodWithAutoClosure(autoClosure: @escaping @autoclosure () -> Int) {
//        self.__methodWithAutoClosure.recordInput(
//            (
//                autoClosure()
//            )
//        )
//        let _invoke = self.__methodWithAutoClosure.closure()
//        _invoke?(
//            autoClosure()
//        )
//    }
//}
