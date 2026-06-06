import Foundation

enum NavigationSelection: Hashable {
    case package(PackageDemo)
    case template(TemplateKind)

    var title: String {
        switch self {
        case .package(let package): package.title
        case .template(let template): template.title
        }
    }

    var symbolName: String {
        switch self {
        case .package(let package): package.symbolName
        case .template(let template): template.symbolName
        }
    }
}
