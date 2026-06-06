import AppKit
import SwiftUI

struct ChiefKitLogoView: View {
    let size: CGFloat
    let cornerRadius: CGFloat

    init(size: CGFloat, cornerRadius: CGFloat? = nil) {
        self.size = size
        self.cornerRadius = cornerRadius ?? max(8, size * 0.22)
    }

    var body: some View {
        Group {
            if let image = ChiefKitAssets.appIconImage() {
                logoImage(image)
            } else {
                fallbackImage
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(.white.opacity(0.28), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.10), radius: max(3, size * 0.08), x: 0, y: max(2, size * 0.04))
    }

    private func logoImage(_ image: NSImage) -> some View {
        Image(nsImage: image)
            .resizable()
            .scaledToFill()
    }

    private var fallbackImage: some View {
        Image(systemName: "cube.transparent")
            .resizable()
            .scaledToFit()
            .padding(size * 0.22)
            .foregroundStyle(.tint)
            .background(.thinMaterial)
    }
}
