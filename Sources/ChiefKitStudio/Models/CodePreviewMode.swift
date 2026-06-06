import Foundation

enum CodePreviewMode: String, CaseIterable, Identifiable {
    case swiftUI = "SwiftUI"
    case package = "Package.swift"
    case data = "State / JSON"

    var id: String { rawValue }
}
