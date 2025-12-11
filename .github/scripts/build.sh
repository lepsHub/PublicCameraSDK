#!/usr/bin/env bash
set -euo pipefail

# expects files created by versioning.sh .release_cam_prefix etc.

build_xcframework() {
  local key="$1"
  if [ "$key" = "cam" ]; then
    SCHEME="CameraSDK"
    XC_OUTPUT="build/CameraSDK.xcframework"
  else
    SCHEME="CoreSDK"
    XC_OUTPUT="build/CoreSDK.xcframework"
  fi

  mkdir -p build
  set -x
  xcodebuild archive -scheme "$SCHEME" -destination "generic/platform=iOS" -archivePath build/ios.xcarchive SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
  xcodebuild archive -scheme "$SCHEME" -destination "generic/platform=iOS Simulator" -archivePath build/sim.xcarchive SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
  xcodebuild -create-xcframework \
    -framework "build/ios.xcarchive/Products/Library/Frameworks/${SCHEME}.framework" \
    -framework "build/sim.xcarchive/Products/Library/Frameworks/${SCHEME}.framework" \
    -output "$XC_OUTPUT"
  set +x

  if [ ! -d "$XC_OUTPUT" ]; then
    echo "ERROR: xcframework not found at $XC_OUTPUT"
    exit 1
  fi

  printf "%s\n" "$XC_OUTPUT" > ".build_${key}_xcoutput"
}

for k in ${AFF// / }; do
  build_xcframework "$k"
done

echo "Build finished. XCFramework paths saved in .build_* files"
