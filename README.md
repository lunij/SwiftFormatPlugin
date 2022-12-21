# SwiftFormatPlugin

A Swift Package Plugin for [SwiftFormat](https://github.com/nicklockwood/SwiftFormat).

It can run SwiftFormat as a pre-build command using the `SwiftFormatPrebuildPlugin`.

It can also run SwiftFormat as a command using either `SwiftFormatCommandPlugin` or the `SwiftFormatRawCommandPlugin`.

This package uses the official SwiftFormat binary.
It does not fetch any source dependencies and does not require to compile SwiftFormat.

## Usage

```swift
.package(url: "https://github.com/lunij/SwiftFormatPlugin", from: "x.y.z")
```

```swift
.target(
    name: "...",
    plugins: [
        .plugin(name: "SwiftFormatPrebuildPlugin", package: "SwiftFormatPlugin")
    ]
)
```

### Terminal

```bash
swift package plugin --allow-writing-to-package-directory format-source-code    # SwiftFormatCommandPlugin
swift package plugin --allow-writing-to-package-directory swiftformat           # SwiftFormatRawCommandPlugin
```
