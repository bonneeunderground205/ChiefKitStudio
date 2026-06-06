import SwiftUI

struct SwiftBlocksDemoView: View {
    @ObservedObject var viewModel: PlaygroundViewModel
    private let galleryItems = ["Primary Button", "Secondary Button", "Metric Surface", "Settings Row", "Status Badge"]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 18) {
                    galleryCard
                    examplesCard
                }

                VStack(alignment: .leading, spacing: 18) {
                    galleryCard
                    examplesCard
                }
            }

            canvasCard
        }
    }

    private var galleryCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("Component Gallery", subtitle: "Reusable blocks ready for product surfaces.")

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 10)], spacing: 10) {
                    ForEach(galleryItems, id: \.self) { item in
                        Button {
                            viewModel.selectedBlockName = item
                        } label: {
                            HStack {
                                Image(systemName: icon(for: item))
                                Text(item)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                Spacer(minLength: 4)
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(
                                viewModel.selectedBlockName == item ? Color.accentColor.opacity(0.15) : Color.clear,
                                in: RoundedRectangle(cornerRadius: 8)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var examplesCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionTitle("Buttons & Surfaces", subtitle: "A quick visual pass over common design-system blocks.")

                ViewThatFits(in: .horizontal) {
                    HStack {
                        exampleButtons
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        exampleButtons
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Usage")
                                .font(.headline)
                            Text("2.4k active users")
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 8)
                        PillLabel(title: "+18%", systemImage: "arrow.up.right")
                    }

                    Divider()

                    HStack {
                        Label("Synced", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Spacer(minLength: 8)
                        Text("Canvas ready")
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .padding(14)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var canvasCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                ViewThatFits(in: .horizontal) {
                    HStack {
                        SectionTitle("Simple Canvas Preview", subtitle: "A drag-and-drop builder mockup for generated SwiftUI.")
                        Spacer(minLength: 12)
                        PillLabel(title: viewModel.selectedBlockName, systemImage: "cursorarrow.click.2")
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        SectionTitle("Simple Canvas Preview", subtitle: "A drag-and-drop builder mockup for generated SwiftUI.")
                        PillLabel(title: viewModel.selectedBlockName, systemImage: "cursorarrow.click.2")
                    }
                }

                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.thinMaterial)
                        .overlay {
                            CanvasGrid()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Dashboard Canvas")
                            .font(.title3.weight(.semibold))

                        ViewThatFits(in: .horizontal) {
                            HStack(spacing: 12) {
                                canvasBlocks
                            }

                            VStack(spacing: 12) {
                                canvasBlocks
                            }
                        }

                        Button(viewModel.selectedBlockName) { }
                            .buttonStyle(.borderedProminent)
                            .lineLimit(1)
                    }
                    .padding(18)
                }
                .frame(minHeight: 280)

                CodeBlockView(text: viewModel.swiftBlocksGeneratedCode)
                    .frame(height: 180)
            }
        }
    }

    @ViewBuilder
    private var exampleButtons: some View {
        Button("Primary Action") { }
            .buttonStyle(.borderedProminent)
            .lineLimit(1)
        Button("Secondary") { }
            .lineLimit(1)
        Button(role: .destructive) {
        } label: {
            Text("Delete")
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private var canvasBlocks: some View {
        CanvasBlock(title: "Revenue", value: "$42.8k", systemImage: "chart.line.uptrend.xyaxis")
        CanvasBlock(title: "Activation", value: "72%", systemImage: "sparkles")
        CanvasBlock(title: "Latency", value: "84 ms", systemImage: "speedometer")
    }

    private func icon(for item: String) -> String {
        switch item {
        case "Primary Button": "button.programmable"
        case "Secondary Button": "rectangle"
        case "Metric Surface": "chart.bar"
        case "Settings Row": "gearshape"
        default: "tag"
        }
    }
}

private struct CanvasBlock: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(.tint)
            Text(value)
                .font(.title3.weight(.semibold))
                .lineLimit(1)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct CanvasGrid: View {
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                let step: CGFloat = 22
                var x: CGFloat = 0
                while x < proxy.size.width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: proxy.size.height))
                    x += step
                }

                var y: CGFloat = 0
                while y < proxy.size.height {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: proxy.size.width, y: y))
                    y += step
                }
            }
            .stroke(.separator.opacity(0.28), lineWidth: 0.5)
        }
    }
}
