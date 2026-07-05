# Changelog

All notable changes to this project will be documented in this file. 

This project adheres to [Semantic Versioning](https://semver.org).

## 🚀 [Version 0.4.0](https://github.com/fetch-rewards/swift-mocking/releases/tag/0.4.0) - July 6, 2026 ([Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/0.3.0...0.4.0))

### ✨ Features

- Remove default values from MockedPropertyType readOnly case ([#180](https://github.com/fetch-rewards/swift-mocking/pull/180))
- Add subscript support ([#184](https://github.com/fetch-rewards/swift-mocking/pull/184))

### 🐛 Bug Fixes

- Fix Sendable closure propagation into generated Arguments type ([#144](https://github.com/fetch-rewards/swift-mocking/pull/144))
- Replace per-property invocation locks with shared state lock ([#145](https://github.com/fetch-rewards/swift-mocking/pull/145))
- Fix autoclosure forwarding in generated mock bodies ([#146](https://github.com/fetch-rewards/swift-mocking/pull/146))

### 🧹 Chores

- Add prepare-release and publish-release skills ([#143](https://github.com/fetch-rewards/swift-mocking/pull/143))
- Treat pre-1.0 breaking changes as minor bumps in prepare-release ([#188](https://github.com/fetch-rewards/swift-mocking/pull/188))
- Fetch tags explicitly in prepare-release sync step ([#189](https://github.com/fetch-rewards/swift-mocking/pull/189))

## 🚀 [Version 0.3.0](https://github.com/fetch-rewards/swift-mocking/releases/tag/0.3.0) - June 18, 2026 ([Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/0.2.2...0.3.0))

### ✨ Features

- Add support for conditionally compiled protocol members ([#137](https://github.com/fetch-rewards/swift-mocking/pull/137))

### 🐛 Bug Fixes

- Ensure Package can build with Xcode 27 ([#141](https://github.com/fetch-rewards/swift-mocking/pull/141))

### 🎨 Formatting

- Run swiftformat ([#138](https://github.com/fetch-rewards/swift-mocking/pull/138))

## 🚀 [Version 0.2.2](https://github.com/fetch-rewards/swift-mocking/releases/tag/0.2.2) - August 8, 2025 ([Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/0.2.1...0.2.2))

### 🐛 Bug Fixes

- Fix race conditions in mock methods and mock properties ([#122](https://github.com/fetch-rewards/swift-mocking/pull/122))

### 🎨 Formatting

- Update SwiftFormat rules to properly format decimal numbers ([#123](https://github.com/fetch-rewards/swift-mocking/pull/123))

### 🧹 Chores

- Update callCount and thrownErrors properties to use checked locks ([#127](https://github.com/fetch-rewards/swift-mocking/pull/127))

## 🚀 [Version 0.2.1](https://github.com/fetch-rewards/swift-mocking/releases/tag/0.2.1) - June 30, 2025 ([Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/0.2.0...0.2.1))

### 🐛 Bug Fixes

- Make MockVoidNonParameterizedMethod.Implementation.invokes public ([#116](https://github.com/fetch-rewards/swift-mocking/pull/116))

### 📝 Documentation

- Add chore to PR template ([#118](https://github.com/fetch-rewards/swift-mocking/pull/118))

### 🛠️ CI/CD

- Add chore label to list of required PR labels ([#117](https://github.com/fetch-rewards/swift-mocking/pull/117))

### 🧹 Chores

- Add local Claude settings to gitignore ([#119](https://github.com/fetch-rewards/swift-mocking/pull/119))

## 🚀 [Version 0.2.0](https://github.com/fetch-rewards/swift-mocking/releases/tag/0.2.0) - June 26, 2025 ([Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/0.1.0...0.2.0))

### ✨ Features

- Add sendableConformance argument to Mocked ([#106](https://github.com/fetch-rewards/swift-mocking/pull/106))

### 🐛 Bug Fixes

- Handle composed and mixed associated type constraints ([#108](https://github.com/fetch-rewards/swift-mocking/pull/108))

### 📦 Dependencies

- Update SwiftFormat minimum version and output version in CI ([#110](https://github.com/fetch-rewards/swift-mocking/pull/110))
- Update Swift Locking, SwiftSyntaxSugar, and SwiftSyntax dependencies ([#114](https://github.com/fetch-rewards/swift-mocking/pull/114))

### 📝 Documentation

- Add SPI badges to README ([#102](https://github.com/fetch-rewards/swift-mocking/pull/102))
- Fix spelling mistake ([#101](https://github.com/fetch-rewards/swift-mocking/pull/101))
- Add more issue templates ([#103](https://github.com/fetch-rewards/swift-mocking/pull/103))
- Add social preview image asset ([#105](https://github.com/fetch-rewards/swift-mocking/pull/105))

### 🧪 Testing

- Refactor MacroArgumentValue, reorganize files, and add unit tests ([#111](https://github.com/fetch-rewards/swift-mocking/pull/111))

### 🔨 Refactoring

- Refactor MacroArgumentValue, reorganize files, and add unit tests ([#111](https://github.com/fetch-rewards/swift-mocking/pull/111))

### 🛠️ CI/CD

- Add CODEOWNERS ([#104](https://github.com/fetch-rewards/swift-mocking/pull/104))
- Update SwiftFormat minimum version and output version in CI ([#110](https://github.com/fetch-rewards/swift-mocking/pull/110))

## 🚀 [Version 0.1.0](https://github.com/fetch-rewards/swift-mocking/releases/tag/0.1.0) - April 23, 2025 ([Full Changelog](https://github.com/fetch-rewards/swift-mocking/commits/0.1.0))

### 🎉 Initial Release

This is the first public release of Swift Mocking, a library that provides a collection of Swift macros used to generate mocks.

This initial release includes:

- `@Mocked` - an attached peer macro that generates a mock class from a protocol declaration.
- `@MockedMembers` - an attached member and member-attribute macro that generates mocked members for a mock declaration.
- `@MockableProperty` - an attached macro that marks a property as being mockable.
- `@MockableMethod` - an attached macro that marks a method as being mockable.
