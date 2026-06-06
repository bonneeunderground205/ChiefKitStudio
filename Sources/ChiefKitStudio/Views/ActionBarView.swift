import SwiftUI

struct ActionBarView: View {
    @ObservedObject var viewModel: PlaygroundViewModel

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            ViewThatFits(in: .horizontal) {
                wideBar
                wrappedBar
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.bar)
        }
    }

    private var wideBar: some View {
        HStack(spacing: 10) {
            statusText
            Spacer()
            actionButtons
        }
    }

    private var wrappedBar: some View {
        VStack(alignment: .leading, spacing: 8) {
            statusText

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 158), spacing: 8)], spacing: 8) {
                actionButtons
            }
        }
    }

    private var statusText: some View {
        Text(viewModel.statusMessage)
            .font(.caption)
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }

    @ViewBuilder
    private var actionButtons: some View {
        actionButton("Copy SwiftUI Code", systemImage: "doc.on.doc") {
            viewModel.copySwiftUICode()
        }

        actionButton("Copy Package.swift Dependency", systemImage: "shippingbox") {
            viewModel.copyPackageDependency()
        }

        actionButton("Export Example File", systemImage: "square.and.arrow.down") {
            viewModel.exportSelectedExample()
        }

        actionButton("Reset Demo", systemImage: "arrow.counterclockwise") {
            viewModel.resetDemo()
        }
    }

    private func actionButton(_ title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
                .frame(maxWidth: .infinity)
        }
    }
}
