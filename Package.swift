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
            url: "https://github.com/nicklockwood/SwiftFormat/releases/download/0.50.6/swiftformat.artifactbundle.zip",
            checksum: "c1b05ab370a9577c87113ecc3c1319867bfa7019d0762a67beb1b67f8f0bf9cc"
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
