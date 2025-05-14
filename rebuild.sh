#!/bin/bash
#
# Rebuild script for Kasimba
# Cleans and rebuilds the app

# Clean and rebuild the app
xcodebuild -project Kasimba.xcodeproj -scheme Kasimba clean
xcodebuild -project Kasimba.xcodeproj -scheme Kasimba build

echo "App rebuilt. You can now run it in Xcode." 