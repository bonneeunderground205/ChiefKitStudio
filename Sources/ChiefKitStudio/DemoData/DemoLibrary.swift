import Foundation

enum DemoLibrary {
    static let defaultFlowJSON = """
    {
      "title": "Launch Onboarding",
      "pages": [
        {
          "id": "welcome",
          "title": "Welcome to ChiefKit",
          "body": "Ship guided onboarding, surveys, quizzes, and setup flows from JSON.",
          "style": "hero",
          "actions": ["Start"]
        },
        {
          "id": "personalize",
          "title": "Personalize the workspace",
          "body": "Ask targeted questions and drive the next screen from user answers.",
          "style": "choice",
          "actions": ["Developer", "Designer", "Founder"]
        },
        {
          "id": "ready",
          "title": "Ready to build",
          "body": "Render the final state as native SwiftUI and keep the flow portable.",
          "style": "completion",
          "actions": ["Finish"]
        }
      ]
    }
    """

    static let swiftStateCode = """
    import SwiftState
    import SwiftUI

    struct CounterState: Codable, Equatable {
        var count = 0
        var isLoading = false
        var message: String?
    }

    enum CounterAction: Equatable {
        case increment
        case decrement
        case loadButtonTapped
        case responseReceived(String)
    }

    let counterReducer = Reducer<CounterState, CounterAction> { state, action in
        switch action {
        case .increment:
            state.count += 1
        case .decrement:
            state.count -= 1
        case .loadButtonTapped:
            state.isLoading = true
            return .run { send in
                try await Task.sleep(for: .seconds(1))
                await send(.responseReceived("Loaded example payload"))
            }
        case .responseReceived(let message):
            state.isLoading = false
            state.message = message
        }
        return .none
    }

    struct CounterPlaygroundView: View {
        @StateStore(counterReducer, initialState: CounterState())
        private var store

        var body: some View {
            VStack(spacing: 16) {
                Text("\\(store.count)")
                    .font(.system(size: 48, weight: .semibold, design: .rounded))

                HStack {
                    Button("-") { store.send(.decrement) }
                    Button("+") { store.send(.increment) }
                    Button("Load") { store.send(.loadButtonTapped) }
                }

                if store.isLoading {
                    ProgressView()
                }
            }
        }
    }
    """

    static let notebookUsageCode = """
    import NotebookFlowKit
    import SwiftUI

    struct OnboardingHost: View {
        let flowJSON: String

        var body: some View {
            NotebookFlowView(json: flowJSON) { event in
                switch event {
                case .completed(let answers):
                    print("Completed", answers)
                case .advanced(let pageID):
                    print("Advanced to", pageID)
                }
            }
        }
    }
    """

    static let swiftBlocksCode = """
    import SwiftBlocks
    import SwiftUI

    struct BlocksCanvasDemo: View {
        @State private var blocks: [CanvasBlock] = [
            .surface(title: "Usage", subtitle: "2.4k active users"),
            .button(title: "Run workflow", role: .primary),
            .metric(title: "Conversion", value: "18.6%")
        ]

        var body: some View {
            BlocksCanvas(blocks: $blocks) { block in
                block
                    .render()
                    .draggable(block.id)
            }
        }
    }
    """

    static func packageSnippet(for selection: NavigationSelection) -> String {
        switch selection {
        case .package(let package):
            return """
            // Package.swift
            dependencies: [
                \(package.packageDependencySnippet)
            ],
            targets: [
                .target(
                    name: "YourApp",
                    dependencies: [
                        \(package.targetDependencySnippet)
                    ]
                )
            ]
            """
        case .template(let template):
            return templateExamples[template]?.dependencySnippet ?? ""
        }
    }

    static let templateExamples: [TemplateKind: TemplateExample] = [
        .loginFlow: TemplateExample(
            kind: .loginFlow,
            explanation: "Use SwiftBlocks for the form shell and SwiftState for validation, submission, and retry handling.",
            requiredPackages: [.swiftState, .swiftBlocks],
            swiftUICode: """
            import SwiftBlocks
            import SwiftState
            import SwiftUI

            struct LoginFlowView: View {
                @State private var email = ""
                @State private var password = ""

                var body: some View {
                    BlockSurface {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Sign in").font(.title2.bold())
                            TextField("Email", text: $email)
                            SecureField("Password", text: $password)
                            BlockButton("Continue", role: .primary) {
                                // store.send(.submit(email, password))
                            }
                        }
                    }
                }
            }
            """
        ),
        .onboardingFlow: TemplateExample(
            kind: .onboardingFlow,
            explanation: "Render a portable JSON flow as native SwiftUI while keeping analytics and completion events in app code.",
            requiredPackages: [.notebookFlowKit],
            swiftUICode: """
            import NotebookFlowKit
            import SwiftUI

            struct ProductOnboardingView: View {
                let flowJSON: String

                var body: some View {
                    NotebookFlowView(json: flowJSON) { event in
                        print("Flow event", event)
                    }
                }
            }
            """
        ),
        .settingsScreen: TemplateExample(
            kind: .settingsScreen,
            explanation: "Compose settings rows and grouped surfaces from reusable SwiftBlocks components.",
            requiredPackages: [.swiftBlocks],
            swiftUICode: """
            import SwiftBlocks
            import SwiftUI

            struct SettingsScreen: View {
                @AppStorage("syncEnabled") private var syncEnabled = true

                var body: some View {
                    BlockSurface {
                        SettingsBlock(title: "Sync") {
                            Toggle("Enable workspace sync", isOn: $syncEnabled)
                            BlockButton("Manage API Keys", role: .secondary) { }
                        }
                    }
                }
            }
            """
        ),
        .apiLoadingState: TemplateExample(
            kind: .apiLoadingState,
            explanation: "Model request state with SwiftState so loading, success, empty, and failure paths stay explicit.",
            requiredPackages: [.swiftState],
            swiftUICode: """
            import SwiftState
            import SwiftUI

            enum ResourceAction {
                case appeared
                case retryTapped
                case response(Result<[String], Error>)
            }

            struct ResourceState {
                var phase: LoadPhase<[String]> = .idle
            }

            let resourceReducer = Reducer<ResourceState, ResourceAction> { state, action in
                switch action {
                case .appeared, .retryTapped:
                    state.phase = .loading
                    return .run { send in
                        await send(.response(.success(["Alpha", "Beta", "Gamma"])))
                    }
                case .response(let result):
                    state.phase = LoadPhase(result)
                    return .none
                }
            }
            """
        ),
        .quizFlow: TemplateExample(
            kind: .quizFlow,
            explanation: "NotebookFlowKit owns the question sequence while SwiftState can persist scoring and progress.",
            requiredPackages: [.swiftState, .notebookFlowKit],
            swiftUICode: """
            import NotebookFlowKit
            import SwiftState
            import SwiftUI

            struct QuizFlowView: View {
                let quizJSON: String

                var body: some View {
                    NotebookFlowView(json: quizJSON) { event in
                        // store.send(.flowEvent(event))
                    }
                }
            }
            """
        )
    ]
}
