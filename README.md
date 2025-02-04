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

## License

This library is released under the MIT license. See [LICENSE](https://github.com/fetch-rewards/swift-mocking/blob/main/LICENSE) for details.
