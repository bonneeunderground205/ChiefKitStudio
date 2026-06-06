import SwiftUI

struct TemplateDemoView: View {
    @ObservedObject var viewModel: PlaygroundViewModel
    let template: TemplateKind

    private var example: TemplateExample? {
        DemoLibrary.templateExamples[template]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 18) {
                    livePreview
                    dependencyCard
                }

                VStack(alignment: .leading, spacing: 18) {
                    livePreview
                    dependencyCard
                }
            }

            explanationCard
        }
    }

    private var livePreview: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("Live Preview", subtitle: "Template-shaped UI using native SwiftUI controls.")

                switch template {
                case .loginFlow:
                    LoginPreview()
                case .onboardingFlow:
                    OnboardingPreview()
                case .settingsScreen:
                    SettingsPreview()
                case .apiLoadingState:
                    LoadingPreview()
                case .quizFlow:
                    QuizPreview()
                }
            }
            .frame(maxWidth: .infinity, minHeight: 320, alignment: .topLeading)
        }
    }

    private var dependencyCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("Required Packages", subtitle: "Copyable Package.swift entries are in the code panel.")

                ForEach(example?.requiredPackages ?? [], id: \.self) { package in
                    HStack(spacing: 10) {
                        Image(systemName: package.symbolName)
                            .foregroundStyle(.tint)
                            .frame(width: 22)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(package.title)
                                .font(.headline)
                                .lineLimit(1)
                            Text(package.repositoryURL)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .textSelection(.enabled)
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                }

                Button {
                    viewModel.copyPackageDependency()
                } label: {
                    Label("Copy Dependencies", systemImage: "doc.on.doc")
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 320, alignment: .topLeading)
        }
    }

    private var explanationCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionTitle("Short Explanation")
                Text(example?.explanation ?? template.summary)
                    .foregroundStyle(.secondary)
                Button {
                    viewModel.copySwiftUICode()
                } label: {
                    Label("Copy Template SwiftUI", systemImage: "curlybraces")
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct LoginPreview: View {
    @State private var email = "developer@chiefkit.dev"
    @State private var password = "password"

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Sign in")
                .font(.title2.weight(.semibold))
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button("Continue") { }
                .buttonStyle(.borderedProminent)
            Text("Validation and submission belong in SwiftState.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct OnboardingPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Welcome to the workspace")
                .font(.title2.weight(.semibold))
            Text("A JSON page can describe content, choices, and actions while NotebookFlowKit renders native screens.")
                .foregroundStyle(.secondary)
            HStack {
                Button("Skip") { }
                Button("Start") { }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct SettingsPreview: View {
    @State private var syncEnabled = true
    @State private var telemetryEnabled = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preferences")
                .font(.title2.weight(.semibold))
            Toggle("Enable workspace sync", isOn: $syncEnabled)
            Toggle("Share diagnostics", isOn: $telemetryEnabled)
            Divider()
            HStack {
                Text("API Key")
                Spacer(minLength: 8)
                Button("Manage") { }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct LoadingPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                ProgressView()
                    .controlSize(.small)
                Text("Loading resources")
                    .font(.headline)
                    .lineLimit(1)
            }
            Text("SwiftState keeps idle, loading, success, empty, and failure states explicit.")
                .foregroundStyle(.secondary)
            Button("Retry") { }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct QuizPreview: View {
    @State private var selected = "Reducers"
    private let answers = ["Reducers", "Side effects", "Bindings"]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Which layer owns state transitions?")
                .font(.title2.weight(.semibold))
            ForEach(answers, id: \.self) { answer in
                Button {
                    selected = answer
                } label: {
                    HStack {
                        Image(systemName: selected == answer ? "largecircle.fill.circle" : "circle")
                        Text(answer)
                        Spacer(minLength: 8)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            Button("Submit Answer") { }
                .buttonStyle(.borderedProminent)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}
