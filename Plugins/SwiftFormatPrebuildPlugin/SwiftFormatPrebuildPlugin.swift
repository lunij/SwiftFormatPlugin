
import PackagePlugin

@main
struct SwiftFormatPrebuildPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {
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
    func createBuildCommands(
        context: XcodeProjectPlugin.XcodePluginContext,
        target: XcodeProjectPlugin.XcodeTarget
    ) throws -> [PackagePlugin.Command] {
        guard target is SourceModuleTarget else {
            return []
        }

        let projectDirectory = context.xcodeProject.directory

        return [
            .prebuildCommand(
                displayName: "Running SwiftFormat at \(projectDirectory)",
                executable: try context.tool(named: "swiftformat").path,
                arguments: [
                    projectDirectory
                ],
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}
#endif
