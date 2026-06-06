# Packaging

ChiefKit Studio includes a macOS packaging script:

```bash
./script/package_macos.sh
```

The script:

- builds the release binary
- creates a standard `.app` bundle
- copies app resources and icon files
- signs the app ad-hoc for local distribution
- creates a compressed DMG with an Applications shortcut
- verifies the DMG checksum

## Output

```text
dist/ChiefKit Studio Setup.dmg
```

## Gatekeeper Note

The generated app is ad-hoc signed. Public distribution without Gatekeeper
warnings requires Apple Developer ID signing and notarization.
