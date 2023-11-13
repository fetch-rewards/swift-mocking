//
//  MockAsyncImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

public enum MockAsyncImplementation<Value> {
    case unimplemented
    case returns(() async -> Value)

    func callAsFunction(for keyPath: AnyKeyPath) async -> Value {
        await switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(keyPath)")
        case .returns(let value):
            value()
        }
    }
}
