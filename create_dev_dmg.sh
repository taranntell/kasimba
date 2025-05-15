#!/bin/bash

# Exit on any error
set -e

# Configuration
APP_NAME="Kasimba"
DMG_NAME="${APP_NAME}.dmg"
BUILD_DIR="build"
RELEASE_DIR="${BUILD_DIR}/Release"

# Colors for output
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${BOLD}${GREEN}Building ${APP_NAME} for distribution...${RESET}"

# Check if teamID needs to be updated
if grep -q "YOUR_TEAM_ID" exportOptions.plist; then
    echo -e "${YELLOW}Warning: Using placeholder Team ID in exportOptions.plist${RESET}"
    echo -e "${YELLOW}For distribution builds, replace 'YOUR_TEAM_ID' with your actual Apple Developer Team ID.${RESET}"
    echo -e "${YELLOW}Continuing with development build...${RESET}"
fi

# Create build directory if it doesn't exist
mkdir -p "${BUILD_DIR}"

# Try to build the app (continue even if clean fails)
echo -e "${YELLOW}Building the app...${RESET}"
xcodebuild -project "${APP_NAME}.xcodeproj" -configuration Release build || {
    echo -e "${RED}Build failed. Exiting.${RESET}"
    exit 1
}

# Check if the build was successful
if [ ! -d "${RELEASE_DIR}/${APP_NAME}.app" ]; then
  echo -e "${RED}Build failed. Application not found at ${RELEASE_DIR}/${APP_NAME}.app${RESET}"
  exit 1
fi

echo -e "${GREEN}Build successful. App found at: ${RELEASE_DIR}/${APP_NAME}.app${RESET}"

# Create a temporary directory for the DMG
TMP_DIR=$(mktemp -d)
echo -e "${YELLOW}Created temp directory: ${TMP_DIR}${RESET}"
# Copy the app directly to the temp directory instead of a subfolder
cp -R "${RELEASE_DIR}/${APP_NAME}.app" "${TMP_DIR}/"

# Create symbolic link to Applications
ln -s /Applications "${TMP_DIR}/Applications"

# Create DMG
echo -e "${YELLOW}Creating DMG file...${RESET}"
hdiutil create -volname "${APP_NAME}" -srcfolder "${TMP_DIR}" -ov -format UDZO "${BUILD_DIR}/${DMG_NAME}"

# Verify DMG was created
if [ -f "${BUILD_DIR}/${DMG_NAME}" ]; then
    echo -e "${BOLD}${GREEN}DMG created successfully at:${RESET}"
    echo -e "${BOLD}${GREEN}$(pwd)/${BUILD_DIR}/${DMG_NAME}${RESET}"
    # Get file size
    DMG_SIZE=$(du -h "${BUILD_DIR}/${DMG_NAME}" | awk '{print $1}')
    echo -e "${YELLOW}File size: ${DMG_SIZE}${RESET}"
else
    echo -e "${RED}Failed to create DMG file.${RESET}"
fi

# Clean up
rm -rf "${TMP_DIR}"

echo -e "${YELLOW}Note: This DMG contains an unsigned app. Your colleague may need to right-click and select 'Open' the first time they use it.${RESET}" 