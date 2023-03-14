
import PackagePlugin

@main
struct SwiftFormatPrebuildPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard target is SourceModuleTarget else {
            return []
        }

        return [
            .prebuildCommand(
                displayName: "Running SwiftFormat at \(target.directory)",
                executable: try context.tool(named: "swiftformat").path,
                arguments: [
                    target.directory
                ],
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftFormatPrebuildPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        guard target is SourceModuleTarget else {
            return []
        }

        return [
            .prebuildCommand(
                displayName: "Running SwiftFormat at \(context.xcodeProject.directory)",
                executable: try context.tool(named: "swiftformat").path,
                arguments: [
                    context.xcodeProject.directory
                ],
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}
#endif
