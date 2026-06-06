# ChiefKit Studio

ChiefKit Studio is a native macOS SwiftUI playground for exploring three ChiefKit
packages:

- SwiftState
- NotebookFlowKit
- SwiftBlocks

The app is designed as a polished MVP for developers who want to inspect live
examples, copy SwiftUI snippets, copy Package.swift dependency entries, and
export example files.

## Highlights

- Native macOS sidebar layout
- Live preview area
- Code preview panel
- Copy and export actions
- Responsive split layout
- Rounded ChiefKit app icon
- macOS DMG packaging script

## Build

```bash
swift build
```

## Run

```bash
./script/build_and_run.sh
```

## Package

```bash
./script/package_macos.sh
```

The generated setup is written to:

```text
dist/ChiefKit Studio Setup.dmg
```

The DMG is intentionally ignored by git.
