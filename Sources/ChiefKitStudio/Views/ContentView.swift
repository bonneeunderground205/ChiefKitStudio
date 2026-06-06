import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PlaygroundViewModel()

    var body: some View {
        NavigationSplitView {
            SidebarView(viewModel: viewModel)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 320)
        } detail: {
            VStack(spacing: 0) {
                GeometryReader { proxy in
                    if proxy.size.width >= 760 {
                        HSplitView {
                            DemoDetailView(viewModel: viewModel)
                                .frame(minWidth: 340)

                            CodePreviewPanel(viewModel: viewModel)
                                .frame(minWidth: 280, idealWidth: min(420, proxy.size.width * 0.36), maxWidth: 560)
                        }
                    } else {
                        VSplitView {
                            DemoDetailView(viewModel: viewModel)
                                .frame(minHeight: 300)

                            CodePreviewPanel(viewModel: viewModel)
                                .frame(minHeight: 240, idealHeight: 320)
                        }
                    }
                }

                ActionBarView(viewModel: viewModel)
            }
        }
    }
}
