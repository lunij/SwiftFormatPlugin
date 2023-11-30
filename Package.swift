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
        .plugin(name: "SwiftFormatPrebuildPlugin", targets: ["SwiftFormatPrebuildPlugin"])
    ],
    targets: [
        .binaryTarget(
            name: "SwiftFormatBinary",
            url: "https://github.com/nicklockwood/SwiftFormat/releases/download/0.52.10/swiftformat.artifactbundle.zip",
            checksum: "6c11b2d50ee6f914ee87e891ad4e4a32e1f82993a8ccecaebd3285ac767b86ce"
        ),
        .plugin(
            name: "SwiftFormatPrebuildPlugin",
            capability: .buildTool(),
            dependencies: ["SwiftFormatBinary"]
        ),
        .plugin(
            name: "SwiftFormatCommandPlugin",
            capability: .command(
                intent: .custom(verb: "swiftformat", description: "Formats Swift source files using SwiftFormat"),
                permissions: [
                    .writeToPackageDirectory(reason: "SwiftFormat formats source files"),
                ]
            ),
            dependencies: ["SwiftFormatBinary"]
        )
    ]
)
