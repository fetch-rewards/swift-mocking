# Changelog

All notable changes to this project will be documented in this file. 

This project adheres to [Semantic Versioning](https://semver.org).

## 🏷️ [Version 0.2.0](https://github.com/fetch-rewards/swift-mocking/releases/tag/0.2.0) - June 26, 2025 ([Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/0.1.0...0.2.0))

### ✨ Features

- Add sendableConformance argument to Mocked ([#106](https://github.com/fetch-rewards/swift-mocking/pull/106))

### 🐛 Bug Fixes

- Handle composed and mixed associated type constraints ([#108](https://github.com/fetch-rewards/swift-mocking/pull/108))

### 📝 Documentation

- Add SPI badges to README ([#102](https://github.com/fetch-rewards/swift-mocking/pull/102))
- Fix spelling mistake ([#101](https://github.com/fetch-rewards/swift-mocking/pull/101))
- Add more issue templates ([#103](https://github.com/fetch-rewards/swift-mocking/pull/103))
- Add social preview image asset ([#105](https://github.com/fetch-rewards/swift-mocking/pull/105))

### 🧪 Testing

- Refactor MacroArgumentValue, reorganize files, and add unit tests ([#111](https://github.com/fetch-rewards/swift-mocking/pull/111))

### 🔨 Refactoring

- Refactor MacroArgumentValue, reorganize files, and add unit tests ([#111](https://github.com/fetch-rewards/swift-mocking/pull/111))

### 📦 Dependencies

- Update SwiftFormat minimum version and output version in CI ([#110](https://github.com/fetch-rewards/swift-mocking/pull/110))
- Update Swift Locking, SwiftSyntaxSugar, and SwiftSyntax dependencies ([#114](https://github.com/fetch-rewards/swift-mocking/pull/114))

### 🛠️ CI/CD

- Add CODEOWNERS ([#104](https://github.com/fetch-rewards/swift-mocking/pull/104))
- Update SwiftFormat minimum version and output version in CI ([#110](https://github.com/fetch-rewards/swift-mocking/pull/110))

## 🏷️ [Version 0.1.0](https://github.com/fetch-rewards/swift-mocking/releases/tag/0.1.0) - April 23, 2025 ([Full Changelog](https://github.com/fetch-rewards/swift-mocking/commits/0.1.0))

### 🚀 Initial Release

This is the first public release of Swift Mocking, a library that provides a collection of Swift macros used to generate mocks.

This initial release includes:

- `@Mocked` - an attached peer macro that generates a mock class from a protocol declaration.
- `@MockedMembers` - an attached member and member-attribute macro that generates mocked members for a mock declaration.
- `@MockableProperty` - an attached macro that marks a property as being mockable.
- `@MockableMethod` - an attached macro that marks a method as being mockable.
