#!/usr/bin/env bash
set -e

HELIUM_APP="${HELIUM_APP:-/Applications/Helium.app}"
CHROME_DMG_URL="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"

TMP_DIR="$(mktemp -d)"
MOUNT_DIR="$TMP_DIR/mnt"
trap 'hdiutil detach -quiet "$MOUNT_DIR" 2>/dev/null; rm -rf "$TMP_DIR"' EXIT

curl -fL --progress-bar -o "$TMP_DIR/chrome.dmg" "$CHROME_DMG_URL"
hdiutil attach -quiet -nobrowse -readonly -mountpoint "$MOUNT_DIR" "$TMP_DIR/chrome.dmg"

CHROME_WIDEVINE="$(echo "$MOUNT_DIR"/Google\ Chrome.app/Contents/Frameworks/Google\ Chrome\ Framework.framework/Versions/[0-9]*/Libraries/WidevineCdm)"
HELIUM_LIBRARIES="$(echo "$HELIUM_APP"/Contents/Frameworks/Helium\ Framework.framework/Versions/[0-9]*/Libraries)"

rm -rf "$HELIUM_LIBRARIES/WidevineCdm"
cp -R "$CHROME_WIDEVINE" "$HELIUM_LIBRARIES/"

xattr -cr "$HELIUM_APP"
codesign --force --deep --sign - "$HELIUM_APP"
