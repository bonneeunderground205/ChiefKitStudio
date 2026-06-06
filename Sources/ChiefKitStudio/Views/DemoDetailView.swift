import SwiftUI

struct DemoDetailView: View {
    @ObservedObject var viewModel: PlaygroundViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HeaderView(selection: viewModel.selection)

                switch viewModel.selection {
                case .package(.swiftState):
                    SwiftStateDemoView(viewModel: viewModel)
                case .package(.notebookFlowKit):
                    NotebookFlowDemoView(viewModel: viewModel)
                case .package(.swiftBlocks):
                    SwiftBlocksDemoView(viewModel: viewModel)
                case .template(let template):
                    TemplateDemoView(viewModel: viewModel, template: template)
                }
            }
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(.background)
    }
}

private struct HeaderView: View {
    let selection: NavigationSelection

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ChiefKitLogoView(size: 52, cornerRadius: 12)

            VStack(alignment: .leading, spacing: 5) {
                Text(selection.title)
                    .font(.largeTitle.weight(.semibold))
                Text(subtitle)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }

    private var subtitle: String {
        switch selection {
        case .package(let package):
            package.purpose
        case .template(let template):
            template.summary
        }
    }
}
