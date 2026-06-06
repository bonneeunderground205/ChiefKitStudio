# ChiefKit Studio

ChiefKit Studio is a native macOS SwiftUI playground for exploring example usage of:

- SwiftState
- NotebookFlowKit
- SwiftBlocks

The first version is intentionally lightweight: it compiles standalone, demonstrates each package visually, and provides copyable `SwiftUI` and `Package.swift` snippets for developers to move into their apps.

## Download

Download the latest macOS DMG setup:

[Download ChiefKit Studio for macOS](https://hnmlabs.com/downloads.php)

## Run

Open `Package.swift` in Xcode 26.5 or later, or run:

```bash
./script/build_and_run.sh
```

The app targets macOS 13+ and uses only SwiftUI/AppKit from the system SDK.

## Package For macOS

Create a signed local `.app` bundle and compressed DMG setup:

```bash
./script/package_macos.sh
```

The generated setup is written to:

```text
dist/ChiefKit Studio Setup.dmg
```
