
import PackagePlugin

@main
struct SwiftFormatBuildPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard target is SourceModuleTarget else {
            return []
        }

        return [
            .buildCommand(
                displayName: "Running SwiftFormat at \(target.directory)",
                executable: try context.tool(named: "swiftformat").path,
                arguments: [
                    "--cache",
                    "ignore",
                    target.directory
                ]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftFormatBuildPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        guard target is SourceModuleTarget else {
            return []
        }

        return [
            .buildCommand(
                displayName: "Running SwiftFormat at \(context.xcodeProject.directory)",
                executable: try context.tool(named: "swiftformat").path,
                arguments: [
                    "--cache",
                    "ignore",
                    context.xcodeProject.directory
                ]
            )
        ]
    }
}
#endif
