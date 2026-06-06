import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: PlaygroundViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    ChiefKitLogoView(size: 34, cornerRadius: 8)

                    Text("ChiefKit Studio")
                        .font(.title3.weight(.semibold))
                        .lineLimit(1)
                }

                Text("Interactive package playground")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Search examples", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
            }
            .padding([.horizontal, .top], 16)
            .padding(.bottom, 10)

            List {
                Section("Packages") {
                    ForEach(viewModel.filteredPackages) { package in
                        SidebarRow(
                            title: package.title,
                            subtitle: package.purpose,
                            systemImage: package.symbolName,
                            isSelected: viewModel.selection == .package(package)
                        ) {
                            viewModel.select(.package(package))
                        }
                    }
                }

                Section("Templates") {
                    ForEach(viewModel.filteredTemplates) { template in
                        SidebarRow(
                            title: template.title,
                            subtitle: template.summary,
                            systemImage: template.symbolName,
                            isSelected: viewModel.selection == .template(template)
                        ) {
                            viewModel.select(.template(template))
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        }
    }
}

private struct SidebarRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: systemImage)
                    .frame(width: 18)
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.callout.weight(isSelected ? .semibold : .regular))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(isSelected ? Color.accentColor.opacity(0.16) : Color.clear)
    }
}
