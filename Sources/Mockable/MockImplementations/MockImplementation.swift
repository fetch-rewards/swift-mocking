//
//  MockImplementation.swift
//  Mockable
//
//  Created by Cole Campbell on 11/11/23.
//

import Foundation
import XCTestDynamicOverlay

public enum MockImplementation<Value> {
    case unimplemented
    case returns(Value)

    func callAsFunction(for keyPath: AnyKeyPath) -> Value {
        switch self {
        case .unimplemented:
            XCTestDynamicOverlay.unimplemented("\(keyPath)")
        case .returns(let value):
            value
        }
    }
}
