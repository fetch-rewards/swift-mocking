//
//  MockedPlugin.swift
//  MockedMacros
//
//  Created by Gray Campbell on 12/7/23.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MockedPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [
        MockedMacro.self,
        MockedMethodMacro.self,
        MockablePropertyMacro.self,
        MockedPropertyMacro.self,
    ]
}
