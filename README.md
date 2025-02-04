# swift-mocking

`swift-mocking` is a collection of Swift macros used to generate mock dependencies.

## Installation

To add `swift-mocking` to a Swift package manifest file:
- Add the `swift-mocking` package to your package's `dependencies`:
  ```swift
  .package(
      url: "https://github.com/fetch-rewards/swift-mocking.git",
      from: "<#latest swift-mocking tag#>"
  )
  ```
- Add the `Mocked` product to your target's `dependencies`:
  ```swift
  .product(name: "Mocked", package: "swift-mocking")
  ```

## Features
`swift-mocking` is Swift 6 compatible, fully concurrency-safe, and generates mocks that can handle:
- [x] Any access level
- [x] Associated types, including primary associated types
- [x] Actor conformance
- [x] Static and instance members
- [x] Read-only properties, including those with getters marked as `async`, `throws`, or `async throws`
- [x] Read-write properties
- [x] Variadic parameters
- [x] Generic methods
- [x] Method overloads
- [ ] Attributed types (`inout`, `consuming`, `sending`, etc.)
- [ ] Typed `throws`

## License

This library is released under the MIT license. See [LICENSE](https://github.com/fetch-rewards/swift-mocking/blob/main/LICENSE) for details.
