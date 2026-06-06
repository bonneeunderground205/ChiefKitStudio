import SwiftUI

struct NotebookFlowDemoView: View {
    @ObservedObject var viewModel: PlaygroundViewModel

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: 18) {
                editorCard
                previewCard
            }

            VStack(alignment: .leading, spacing: 18) {
                editorCard
                previewCard
            }
        }
    }

    private var editorCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("Editable JSON Flow", subtitle: "Edit the source and watch the native preview update.")

                TextEditor(text: $viewModel.flowJSON)
                    .font(.system(.callout, design: .monospaced))
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .frame(minHeight: 360)
                    .background(Color(nsColor: .textBackgroundColor).opacity(0.55), in: RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.separator.opacity(0.35), lineWidth: 1)
                    }

                ViewThatFits(in: .horizontal) {
                    HStack {
                        flowActionButtons
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        flowActionButtons
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var previewCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("Live Preview", subtitle: "A native approximation of a NotebookFlowKit-rendered flow.")

                switch FlowDefinition.decode(viewModel.flowJSON) {
                case .success(let flow):
                    FlowPreview(definition: flow)
                case .failure(let error):
                    VStack(alignment: .leading, spacing: 10) {
                        Label("JSON could not be decoded", systemImage: "exclamationmark.triangle")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 360, alignment: .topLeading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var flowActionButtons: some View {
        Button {
            viewModel.exportFlowJSON()
        } label: {
            Label("Export JSON", systemImage: "square.and.arrow.down")
                .lineLimit(1)
        }

        Button {
            viewModel.copyNotebookUsageCode()
        } label: {
            Label("Copy SwiftUI Usage", systemImage: "doc.on.doc")
                .lineLimit(1)
        }
    }
}

private struct FlowPreview: View {
    let definition: FlowDefinition

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(definition.title)
                .font(.title2.weight(.semibold))

            ForEach(Array(definition.pages.enumerated()), id: \.element.id) { index, page in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("\(index + 1)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(Color.accentColor, in: Circle())

                        Text(page.title)
                            .font(.headline)
                            .lineLimit(2)

                        Spacer(minLength: 8)

                        Text(page.style)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Text(page.body)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 8)], alignment: .leading, spacing: 8) {
                        ForEach(page.actions, id: \.self) { action in
                            Button(action) { }
                                .buttonStyle(.bordered)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(14)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 360, alignment: .topLeading)
    }
}
