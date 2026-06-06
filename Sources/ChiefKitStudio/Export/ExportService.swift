import AppKit
import Foundation

enum ExportService {
    static func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }

    @MainActor
    static func export(text: String, suggestedFileName: String) throws -> URL? {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = suggestedFileName
        panel.canCreateDirectories = true
        panel.title = "Export Example File"

        guard panel.runModal() == .OK, let url = panel.url else {
            return nil
        }

        try text.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}
