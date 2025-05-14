#!/bin/bash

# Set variables
APP_NAME="Kasimba"
VERSION="1.0"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
VOLUME_NAME="${APP_NAME} ${VERSION}"
SOURCE_DIR="$(pwd)"
BUILD_DIR="${SOURCE_DIR}/build"
RELEASE_DIR="${BUILD_DIR}/Release"
APP_PATH="${RELEASE_DIR}/${APP_NAME}.app"
DMG_PATH="${BUILD_DIR}/${DMG_NAME}"

# Build the application
echo "Building ${APP_NAME}..."
xcodebuild -project "${APP_NAME}.xcodeproj" -configuration Release clean build

# Check if the build was successful
if [ ! -d "${APP_PATH}" ]; then
  echo "Build failed. Application not found at ${APP_PATH}"
  exit 1
fi

# Create a temporary directory for the DMG
TMP_DIR=$(mktemp -d)
mkdir -p "${TMP_DIR}/${APP_NAME}"
cp -R "${APP_PATH}" "${TMP_DIR}/${APP_NAME}/"
cp "${SOURCE_DIR}/README.md" "${TMP_DIR}/${APP_NAME}/"

# Create symbolic link to Applications
ln -s /Applications "${TMP_DIR}/Applications"

# Create DMG
echo "Creating DMG..."
hdiutil create -volname "${VOLUME_NAME}" -srcfolder "${TMP_DIR}" -ov -format UDZO "${DMG_PATH}"

# Clean up
rm -rf "${TMP_DIR}"

echo "DMG created successfully at ${DMG_PATH}" 