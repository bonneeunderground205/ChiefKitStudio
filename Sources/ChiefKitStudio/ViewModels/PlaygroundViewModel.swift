import Foundation

@MainActor
final class PlaygroundViewModel: ObservableObject {
    @Published var selection: NavigationSelection = .package(.swiftState)
    @Published var searchText = ""
    @Published var codePreviewMode: CodePreviewMode = .swiftUI

    @Published var counter = 0
    @Published var isLoading = false
    @Published var loadedMessage: String?
    @Published var timeline: [TimelineEvent] = [
        TimelineEvent(action: ".initial", state: "count: 0", timestamp: .now)
    ]

    @Published var flowJSON = DemoLibrary.defaultFlowJSON
    @Published var selectedBlockName = "Primary Button"
    @Published var statusMessage = "Ready"

    var filteredPackages: [PackageDemo] {
        PackageDemo.allCases.filter { matches($0.title, $0.purpose) }
    }

    var filteredTemplates: [TemplateKind] {
        TemplateKind.allCases.filter { matches($0.title, $0.summary) }
    }

    var selectedSwiftUICode: String {
        switch selection {
        case .package(.swiftState):
            DemoLibrary.swiftStateCode
        case .package(.notebookFlowKit):
            DemoLibrary.notebookUsageCode
        case .package(.swiftBlocks):
            DemoLibrary.swiftBlocksCode
        case .template(let template):
            DemoLibrary.templateExamples[template]?.swiftUICode ?? ""
        }
    }

    var selectedDependencyCode: String {
        DemoLibrary.packageSnippet(for: selection)
    }

    var selectedDataPreview: String {
        switch selection {
        case .package(.swiftState):
            stateJSONPreview
        case .package(.notebookFlowKit):
            flowJSON
        case .package(.swiftBlocks):
            swiftBlocksGeneratedCode
        case .template(let template):
            DemoLibrary.templateExamples[template]?.explanation ?? template.summary
        }
    }

    var codePanelText: String {
        switch codePreviewMode {
        case .swiftUI:
            selectedSwiftUICode
        case .package:
            selectedDependencyCode
        case .data:
            selectedDataPreview
        }
    }

    var stateJSONPreview: String {
        let state: [String: Any] = [
            "count": counter,
            "isLoading": isLoading,
            "message": loadedMessage ?? NSNull(),
            "timelineCount": timeline.count
        ]

        guard
            let data = try? JSONSerialization.data(withJSONObject: state, options: [.prettyPrinted, .sortedKeys]),
            let text = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }

        return text
    }

    var swiftBlocksGeneratedCode: String {
        """
        VStack(alignment: .leading, spacing: 16) {
            BlockButton("\(selectedBlockName)", role: .primary) {
                print("Tapped \(selectedBlockName)")
            }

            BlockSurface {
                Text("Surface")
                Text("Reusable macOS-ready content block")
            }
        }
        """
    }

    func select(_ selection: NavigationSelection) {
        self.selection = selection
        statusMessage = "Showing \(selection.title)"
    }

    func incrementCounter() {
        counter += 1
        appendTimeline(action: ".increment")
    }

    func decrementCounter() {
        counter -= 1
        appendTimeline(action: ".decrement")
    }

    func runAsyncSimulation() {
        guard !isLoading else { return }
        isLoading = true
        loadedMessage = nil
        appendTimeline(action: ".loadButtonTapped")

        Task {
            try? await Task.sleep(for: .milliseconds(950))
            loadedMessage = "Loaded demo payload at \(Date.now.formatted(date: .omitted, time: .standard))"
            isLoading = false
            appendTimeline(action: ".responseReceived")
        }
    }

    func resetDemo() {
        counter = 0
        isLoading = false
        loadedMessage = nil
        timeline = [TimelineEvent(action: ".reset", state: "count: 0", timestamp: .now)]
        flowJSON = DemoLibrary.defaultFlowJSON
        selectedBlockName = "Primary Button"
        statusMessage = "Demo reset"
    }

    func copySwiftUICode() {
        ExportService.copyToClipboard(selectedSwiftUICode)
        statusMessage = "Copied SwiftUI code"
    }

    func copyPackageDependency() {
        ExportService.copyToClipboard(selectedDependencyCode)
        statusMessage = "Copied Package.swift dependency"
    }

    func copyNotebookUsageCode() {
        ExportService.copyToClipboard(DemoLibrary.notebookUsageCode)
        statusMessage = "Copied NotebookFlowKit usage"
    }

    func exportFlowJSON() {
        Task {
            do {
                let url = try ExportService.export(text: flowJSON, suggestedFileName: "NotebookFlow.json")
                statusMessage = url == nil ? "Export cancelled" : "Exported NotebookFlow.json"
            } catch {
                statusMessage = "Export failed: \(error.localizedDescription)"
            }
        }
    }

    func exportSelectedExample() {
        Task {
            do {
                let fileName = "\(selection.title.replacingOccurrences(of: " ", with: "")).swift"
                let url = try ExportService.export(text: selectedSwiftUICode, suggestedFileName: fileName)
                statusMessage = url == nil ? "Export cancelled" : "Exported \(fileName)"
            } catch {
                statusMessage = "Export failed: \(error.localizedDescription)"
            }
        }
    }

    private func appendTimeline(action: String) {
        timeline.insert(
            TimelineEvent(action: action, state: "count: \(counter)", timestamp: .now),
            at: 0
        )

        if timeline.count > 8 {
            timeline.removeLast()
        }
    }

    private func matches(_ title: String, _ details: String) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }
        return title.localizedCaseInsensitiveContains(query)
            || details.localizedCaseInsensitiveContains(query)
    }
}
