import Foundation

enum TemplateKind: String, CaseIterable, Identifiable, Hashable {
    case loginFlow
    case onboardingFlow
    case settingsScreen
    case apiLoadingState
    case quizFlow

    var id: String { rawValue }

    var title: String {
        switch self {
        case .loginFlow: "Login Flow"
        case .onboardingFlow: "Onboarding Flow"
        case .settingsScreen: "Settings Screen"
        case .apiLoadingState: "API Loading State"
        case .quizFlow: "Quiz Flow"
        }
    }

    var symbolName: String {
        switch self {
        case .loginFlow: "person.badge.key"
        case .onboardingFlow: "sparkles.rectangle.stack"
        case .settingsScreen: "gearshape.2"
        case .apiLoadingState: "arrow.down.doc"
        case .quizFlow: "questionmark.app"
        }
    }

    var summary: String {
        switch self {
        case .loginFlow: "A compact authentication screen with validation-ready fields."
        case .onboardingFlow: "A JSON-backed welcome sequence for product education."
        case .settingsScreen: "A native preferences surface built from reusable blocks."
        case .apiLoadingState: "A reducer-driven async loading state with retry."
        case .quizFlow: "A multi-step question flow with selectable answers."
        }
    }
}
