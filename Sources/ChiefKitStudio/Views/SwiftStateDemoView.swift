import SwiftUI

struct SwiftStateDemoView: View {
    @ObservedObject var viewModel: PlaygroundViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 18) {
                    counterCard
                    asyncCard
                }

                VStack(alignment: .leading, spacing: 18) {
                    counterCard
                    asyncCard
                }
            }

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 18) {
                    timelineCard
                    statePreviewCard
                }

                VStack(alignment: .leading, spacing: 18) {
                    timelineCard
                    statePreviewCard
                }
            }
        }
    }

    private var counterCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 18) {
                SectionTitle("Counter Example", subtitle: "Reducer-style state changes with explicit actions.")

                Text("\(viewModel.counter)")
                    .font(.system(size: 54, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity)

                HStack {
                    Button {
                        viewModel.decrementCounter()
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 28, height: 24)
                    }
                    .keyboardShortcut("-", modifiers: [])

                    Button {
                        viewModel.incrementCounter()
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 28, height: 24)
                    }
                    .keyboardShortcut("+", modifiers: [])

                    Spacer(minLength: 8)

                    PillLabel(title: "Binding ready", systemImage: "link")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var asyncCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                SectionTitle("Async Loading", subtitle: "Simulates an effect that dispatches a response action.")

                HStack(spacing: 12) {
                    Button {
                        viewModel.runAsyncSimulation()
                    } label: {
                        Label("Run Effect", systemImage: "bolt.fill")
                            .lineLimit(1)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoading)

                    if viewModel.isLoading {
                        ProgressView()
                            .controlSize(.small)
                    }
                }

                Text(viewModel.loadedMessage ?? "No payload loaded yet.")
                    .foregroundStyle(viewModel.loadedMessage == nil ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                PillLabel(title: viewModel.isLoading ? "loading" : "idle", systemImage: "circle.dashed")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var timelineCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("Action / State Timeline", subtitle: "A compact time-travel debugging preview.")

                VStack(spacing: 8) {
                    ForEach(viewModel.timeline) { event in
                        HStack(spacing: 10) {
                            Text(event.timeText)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .frame(width: 82, alignment: .leading)

                            Text(event.action)
                                .font(.system(.callout, design: .monospaced))
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(event.state)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        .padding(9)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var statePreviewCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("State JSON Preview", subtitle: "Useful for snapshots, debugging, and export.")
                CodeBlockView(text: viewModel.stateJSONPreview)
                    .frame(minHeight: 230)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
