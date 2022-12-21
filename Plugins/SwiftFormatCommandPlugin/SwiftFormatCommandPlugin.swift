
import Foundation
import PackagePlugin

@main
struct SwiftFormatCommandPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let tool = try context.tool(named: "swiftformat")
        let toolUrl = URL(fileURLWithPath: tool.path.string)

        for target in context.package.targets {
            guard let target = target as? SourceModuleTarget else { continue }

            let process = Process()
            process.executableURL = toolUrl
            process.arguments = [
                "--config",
                "\(context.package.directory.string)/.swiftformat",
                "\(target.directory)"
            ]

            print(toolUrl.path, process.arguments!.joined(separator: " "))

            try process.run()
            process.waitUntilExit()

            if process.terminationReason == .exit && process.terminationStatus == 0 {
                print("Formatted the source code in \(target.directory)")
            } else {
                Diagnostics.error("SwiftFormat failed at \(target.directory)")
            }
        }
    }
}
