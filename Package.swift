// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "SwiftFormatPlugin",
    platforms: [
        .iOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15),
        .tvOS(.v13)
    ],
    products: [
        .plugin(name: "SwiftFormatCommandPlugin", targets: ["SwiftFormatCommandPlugin"]),
        .plugin(name: "SwiftFormatPrebuildPlugin", targets: ["SwiftFormatPrebuildPlugin"]),
        .plugin(name: "SwiftFormatRawCommandPlugin", targets: ["SwiftFormatRawCommandPlugin"])
    ],
    targets: [
        .binaryTarget(
            name: "swiftformat",
            url: "https://github.com/nicklockwood/SwiftFormat/releases/download/0.50.7/swiftformat.artifactbundle.zip",
            checksum: "bb98990260e4c84791fde11f019d76d15e79846bd637633a3a026fd5c0fbd0db"
        ),
        .plugin(
            name: "SwiftFormatPrebuildPlugin",
            capability: .buildTool(),
            dependencies: ["swiftformat"]
        ),
        .plugin(
            name: "SwiftFormatCommandPlugin",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [
                    .writeToPackageDirectory(reason: "SwiftFormat formats source files")
                ]
            ),
            dependencies: ["swiftformat"]
        ),
        .plugin(
            name: "SwiftFormatRawCommandPlugin",
            capability: .command(
                intent: .custom(verb: "swiftformat", description: "Formats Swift source files using SwiftFormat"),
                permissions: [
                    .writeToPackageDirectory(reason: "SwiftFormat formats source files"),
                ]
            ),
            dependencies: ["swiftformat"]
        )
    ]
)
