#!/bin/bash
set -e

xcrun actool Assets.xcassets --compile build --platform iphoneos --minimum-deployment-target 9.0 --app-icon AppIcon --output-partial-info-plist build/partial.plist
