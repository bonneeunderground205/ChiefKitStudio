import Foundation

struct TemplateExample: Identifiable, Hashable {
    var id: TemplateKind { kind }
    let kind: TemplateKind
    let explanation: String
    let requiredPackages: [PackageDemo]
    let swiftUICode: String

    var dependencySnippet: String {
        let packages = requiredPackages
            .map(\.packageDependencySnippet)
            .joined(separator: ",\n")

        let products = requiredPackages
            .map(\.targetDependencySnippet)
            .joined(separator: ",\n")

        return """
        dependencies: [
        \(packages.indented(by: 4))
        ],
        targets: [
            .target(
                name: "YourApp",
                dependencies: [
        \(products.indented(by: 12))
                ]
            )
        ]
        """
    }
}
