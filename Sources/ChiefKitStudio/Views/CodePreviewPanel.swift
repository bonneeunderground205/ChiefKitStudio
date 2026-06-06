import SwiftUI

struct CodePreviewPanel: View {
    @ObservedObject var viewModel: PlaygroundViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Label("Code Preview", systemImage: "curlybraces")
                    .font(.headline)
                    .lineLimit(1)

                Spacer()

                Picker("Preview", selection: $viewModel.codePreviewMode) {
                    ForEach(CodePreviewMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .frame(minWidth: 210, idealWidth: 280, maxWidth: 300)
                .labelsHidden()
            }
            .padding(16)

            Divider()

            CodeBlockView(text: viewModel.codePanelText)
                .padding(16)
        }
        .background(.bar)
    }
}
