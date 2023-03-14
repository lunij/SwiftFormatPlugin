
import Foundation
import PackagePlugin

@main
struct SwiftFormatRawCommandPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        if arguments.contains("--verbose") {
            print("Command plugin execution with arguments \(arguments.description) for Swift package \(context.package.displayName). All target information: \(context.package.targets.description)")
        }

        var targetsToProcess: [Target] = context.package.targets
        var argExtractor = ArgumentExtractor(arguments)
        let selectedTargets = argExtractor.extractOption(named: "target")

        if selectedTargets.isEmpty == false {
            targetsToProcess = context.package.targets.filter { selectedTargets.contains($0.name) }.map { $0 }
        }

        for target in targetsToProcess {
            guard let target = target as? SourceModuleTarget else { continue }

            try formatCode(in: target.directory, context: context, arguments: argExtractor.remainingArguments)
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftFormatRawCommandPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        if arguments.contains("--verbose") {
            print("Command plugin execution with arguments \(arguments.description) for Swift package \(context.xcodeProject.displayName). All target information: \(context.xcodeProject.targets.description)")
            print("Plugin will run for directory: \(context.xcodeProject.directory.description)")
        }

        var argExtractor = ArgumentExtractor(arguments)
        _ = argExtractor.extractOption(named: "target")

        try formatCode(in: context.xcodeProject.directory, context: context, arguments: argExtractor.remainingArguments)
    }
}
#endif

extension CommandPlugin {
    func formatCode(in directory: Path, context: Context, arguments: [String]) throws {
        print("Running SwiftFormat at \(directory)")

        let tool = try context.tool(named: "swiftformat")
        let toolURL = URL(fileURLWithPath: tool.path.string)

        var processArguments = [directory.string]
        processArguments.append(contentsOf: arguments)

        let process = Process()
        process.executableURL = toolURL
        process.arguments = processArguments

        try process.run()
        process.waitUntilExit()

        guard process.terminationReason == .exit, process.terminationStatus == 0 else {
            Diagnostics.error("SwiftFormat failed at \(directory.string)")
            return
        }
    }
}
