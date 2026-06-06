import AppKit
import Foundation

enum ChiefKitAssets {
    static func logoImage() -> NSImage? {
        image(named: "ChiefKitLogo")
    }

    static func appIconImage() -> NSImage? {
        image(named: "ChiefKitAppIcon")
    }

    private static func image(named name: String) -> NSImage? {
        let urls = [
            Bundle.main.resourceURL?.appendingPathComponent("\(name).png"),
            Bundle.module.url(forResource: name, withExtension: "png")
        ].compactMap { $0 }

        for url in urls {
            if let image = NSImage(contentsOf: url) {
                return image
            }
        }

        return nil
    }
}
