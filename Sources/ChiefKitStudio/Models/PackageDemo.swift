import Foundation

enum PackageDemo: String, CaseIterable, Identifiable, Hashable {
    case swiftState
    case notebookFlowKit
    case swiftBlocks

    var id: String { rawValue }

    var title: String {
        switch self {
        case .swiftState: "SwiftState"
        case .notebookFlowKit: "NotebookFlowKit"
        case .swiftBlocks: "SwiftBlocks"
        }
    }

    var repositoryURL: String {
        switch self {
        case .swiftState: "https://github.com/ChiefVenzox/SwiftState.git"
        case .notebookFlowKit: "https://github.com/ChiefVenzox/NotebookFlowKit.git"
        case .swiftBlocks: "https://github.com/ChiefVenzox/SwiftBlocks.git"
        }
    }

    var packageIdentity: String {
        switch self {
        case .swiftState: "swiftstate"
        case .notebookFlowKit: "notebookflowkit"
        case .swiftBlocks: "swiftblocks"
        }
    }

    var purpose: String {
        switch self {
        case .swiftState:
            "State, reducers, async effects, middleware, bindings, and time travel."
        case .notebookFlowKit:
            "JSON-defined onboarding, survey, quiz, setup wizard, and learning flows."
        case .swiftBlocks:
            "Design-system blocks, reusable components, and a drag-and-drop canvas builder."
        }
    }

    var symbolName: String {
        switch self {
        case .swiftState: "point.3.connected.trianglepath.dotted"
        case .notebookFlowKit: "rectangle.on.rectangle.angled"
        case .swiftBlocks: "square.grid.3x3"
        }
    }

    var packageDependencySnippet: String {
        """
        .package(url: "\(repositoryURL)", branch: "main")
        """
    }

    var targetDependencySnippet: String {
        """
        .product(name: "\(title)", package: "\(packageIdentity)")
        """
    }
}
