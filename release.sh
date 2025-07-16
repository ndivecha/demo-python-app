#!/bin/bash
set -e

PROJECT_ROOT=$(pwd)
APP_NAME="demo"
VERSION_FILE="$PROJECT_ROOT/version.txt"
SETUP_FILE="$PROJECT_ROOT/setup.py"
UPDATE_DIR="$PROJECT_ROOT/update-server"
DIST_DIR="$PROJECT_ROOT/dist"

# Read current version (e.g., 1.0.1) and increment patch
OLD_VERSION=$(cat "$VERSION_FILE")
IFS='.' read -r MAJOR MINOR PATCH <<< "$OLD_VERSION"
NEW_VERSION="${MAJOR}.${MINOR}.$((PATCH + 1))"

echo "Bumping version: $OLD_VERSION -> $NEW_VERSION"

# Update version.txt
echo "$NEW_VERSION" > "$VERSION_FILE"

# Update setup.py
sed -i "s/version=\"$OLD_VERSION\"/version=\"$NEW_VERSION\"/" "$SETUP_FILE"

# Clean previous build
rm -rf "$DIST_DIR"
python3 -m build

# Prepare update-server directory
mkdir -p "$UPDATE_DIR"
cp "$DIST_DIR/${APP_NAME}-${NEW_VERSION}.tar.gz" "$UPDATE_DIR/"
echo "$NEW_VERSION" > "$UPDATE_DIR/latest.txt"
(
  cd "$UPDATE_DIR"
  sha256sum "${APP_NAME}-${NEW_VERSION}.tar.gz" > sha256.txt
)

# Launch HTTP server
echo "Starting local HTTP server on port 51810..."
cd "$UPDATE_DIR"
python3 -m http.server 51810
