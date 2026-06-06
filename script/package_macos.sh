#!/usr/bin/env bash
set -euo pipefail

APP_NAME="ChiefKitStudio"
DISPLAY_NAME="ChiefKit Studio"
BUNDLE_ID="com.chiefvenzox.ChiefKitStudio"
VERSION="1.0.0"
MIN_SYSTEM_VERSION="13.0"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/chiefkitstudio-package.XXXXXX")"
trap 'rm -rf "$WORK_DIR"' EXIT

APP_BUNDLE="$WORK_DIR/$DISPLAY_NAME.app"
APP_CONTENTS="$APP_BUNDLE/Contents"
APP_MACOS="$APP_CONTENTS/MacOS"
APP_RESOURCES="$APP_CONTENTS/Resources"
APP_BINARY="$APP_MACOS/$APP_NAME"
INFO_PLIST="$APP_CONTENTS/Info.plist"
ICON_SOURCE="$ROOT_DIR/Sources/ChiefKitStudio/Resources/ChiefKitStudio.icns"
LOGO_SOURCE="$ROOT_DIR/Sources/ChiefKitStudio/Resources/ChiefKitLogo.png"
APP_ICON_SOURCE="$ROOT_DIR/Sources/ChiefKitStudio/Resources/ChiefKitAppIcon.png"

DMG_STAGING="$WORK_DIR/dmg-staging"
TEMP_DMG_PATH="$WORK_DIR/$DISPLAY_NAME Setup.dmg"
DMG_PATH="$DIST_DIR/$DISPLAY_NAME Setup.dmg"

echo "Building $DISPLAY_NAME release..."
swift build -c release

BUILD_BIN_PATH="$(swift build -c release --show-bin-path)"
BUILD_BINARY="$BUILD_BIN_PATH/$APP_NAME"

echo "Creating app bundle..."
mkdir -p "$DIST_DIR"
rm -rf "$APP_BUNDLE" "$DMG_STAGING" "$TEMP_DMG_PATH" "$DMG_PATH"
mkdir -p "$APP_MACOS" "$APP_RESOURCES"

cp "$BUILD_BINARY" "$APP_BINARY"
chmod +x "$APP_BINARY"

if [[ -f "$ICON_SOURCE" ]]; then
  cp "$ICON_SOURCE" "$APP_RESOURCES/ChiefKitStudio.icns"
fi

if [[ -f "$LOGO_SOURCE" ]]; then
  cp "$LOGO_SOURCE" "$APP_RESOURCES/ChiefKitLogo.png"
fi

if [[ -f "$APP_ICON_SOURCE" ]]; then
  cp "$APP_ICON_SOURCE" "$APP_RESOURCES/ChiefKitAppIcon.png"
fi

cat >"$INFO_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleName</key>
  <string>$DISPLAY_NAME</string>
  <key>CFBundleDisplayName</key>
  <string>$DISPLAY_NAME</string>
  <key>CFBundleIconFile</key>
  <string>ChiefKitStudio</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>$VERSION</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSMinimumSystemVersion</key>
  <string>$MIN_SYSTEM_VERSION</string>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
</dict>
</plist>
PLIST

echo "Signing app bundle ad-hoc..."
xattr -cr "$APP_BUNDLE"
codesign --force --deep --sign - "$APP_BUNDLE"
codesign --verify --deep --strict "$APP_BUNDLE"

echo "Creating DMG setup..."
mkdir -p "$DMG_STAGING"
ditto --noextattr --noqtn "$APP_BUNDLE" "$DMG_STAGING/$DISPLAY_NAME.app"
xattr -cr "$DMG_STAGING/$DISPLAY_NAME.app"
ln -s /Applications "$DMG_STAGING/Applications"

hdiutil create \
  -volname "$DISPLAY_NAME" \
  -fs HFS+ \
  -srcfolder "$DMG_STAGING" \
  -ov \
  -format UDZO \
  "$TEMP_DMG_PATH"

hdiutil verify "$TEMP_DMG_PATH"
cp "$TEMP_DMG_PATH" "$DMG_PATH"

echo "Done:"
echo "$DMG_PATH"
