
import PackagePlugin

protocol Context {
    func tool(named name: String) throws -> PackagePlugin.PluginContext.Tool
}

extension PluginContext: Context {}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension XcodePluginContext: Context {}
#endif
