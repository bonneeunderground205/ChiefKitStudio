import Foundation

extension String {
    func indented(by spaces: Int) -> String {
        let padding = String(repeating: " ", count: spaces)
        return split(separator: "\n", omittingEmptySubsequences: false)
            .map { padding + $0 }
            .joined(separator: "\n")
    }
}
