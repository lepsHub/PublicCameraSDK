#!/usr/bin/env bash
set -euo pipefail

# expects .release_* and .build_* and GH_TOKEN env. COCOAPODS_TRUNK_TOKEN optional.

if [ -z "${GH_TOKEN:-}" ]; then
  echo "GH_TOKEN is required"; exit 1
fi

for k in ${AFF// / }; do
  tag="$(cat .release_${k}_full)"
  xcoutput="$(cat .build_${k}_xcoutput)"
  if [ "$k" = "cam" ]; then
    # Truvideo/truvideo-sdk-ios-camera-pod
    # truvideo-sdk-camera.podspec
    # Truvideo/truvideo-sdk-ios-camera
    # TruvideoSdkCamera
    POD_REPO="lepsHub/CameraSDK-pod"
    PODSPEC_NAME="camera.podspec"
    SPM_REPO="lepsHub/PublicCameraSDK"
    PACKAGE_FILE="Package.swift"
    BINARY_NAME="CameraSDK"
  else
    # Truvideo/truvideo-sdk-ios-core-pod
    # truvideo-sdk-core.podspec
    # Truvideo/truvideo-sdk-ios-core
    # TruvideoSdkCore
    POD_REPO="lepsHub/CoreSDK-pod"
    PODSPEC_NAME="core.podspec"
    SPM_REPO="lepsHub/PublicCoreSDK"
    PACKAGE_FILE="Package.swift"
    BINARY_NAME="CoreSDK"
  fi

  # Prepare podrepo workspace
  # config user.name "truvideo[bot]"
  # config user.email "truvideo[bot]@users.noreply.github.com"
  rm -rf /tmp/podrepo || true
  git clone "https://${GH_TOKEN}@github.com/${POD_REPO}.git" /tmp/podrepo
  cd /tmp/podrepo
  git config user.name "truvideo[bot]"
  git config user.email "truvideo[bot]@users.noreply.github.com"
  rm -rf ${BINARY_NAME}*.xcframework || true
  cp -R "${GITHUB_WORKSPACE}/${xcoutput}" .
  if [ -f "${GITHUB_WORKSPACE}/${PODSPEC_NAME}" ]; then cp "${GITHUB_WORKSPACE}/${PODSPEC_NAME}" . || true; fi
  sed -i '' "s/spec.version *= *'.*'/spec.version = '${tag}'/" "${PODSPEC_NAME}" || true
  git checkout -b "${tag}" || git checkout "${tag}" || true
  git add .
  if ! git diff --cached --quiet; then git commit -m "Release ${tag}"; fi
  git push "https://${GH_TOKEN}@github.com/${POD_REPO}.git" "refs/heads/${tag}:refs/heads/${tag}" || true
  git tag "${tag}" || true
  git push "https://${GH_TOKEN}@github.com/${POD_REPO}.git" "refs/tags/${tag}" || true

  # pod trunk push (optional)
  if [ -n "${COCOAPODS_TRUNK_TOKEN:-}" ]; then
    pod trunk push "${PODSPEC_NAME}" --allow-warnings || echo "pod trunk push failed (non-fatal)"
  fi

  # config user.name "truvideo[bot]"
  # config user.email "truvideo[bot]@users.noreply.github.com"
  # SPM repo update
  rm -rf /tmp/spm || true
  git clone "https://${GH_TOKEN}@github.com/${SPM_REPO}.git" /tmp/spm
  cd /tmp/spm
  git config user.name "truvideo[bot]"
  git config user.email "truvideo[bot]@users.noreply.github.com"
  RELEASE_ZIP_NAME="${tag}-${k}.xcframework.zip"
  curl -L -o "/tmp/${RELEASE_ZIP_NAME}" "https://github.com/${SPM_REPO}/releases/download/${tag}/${RELEASE_ZIP_NAME}" || true
  # compute checksum
  if command -v swift >/dev/null 2>&1; then
    CHECKSUM=$(swift package compute-checksum "/tmp/${RELEASE_ZIP_NAME}" 2>/dev/null)
  else
    CHECKSUM=$(shasum -a 256 "/tmp/${RELEASE_ZIP_NAME}" | awk '{print $1}')
  fi

  cat > "${PACKAGE_FILE}" <<SWIFT
// swift-tools-version:5.8
import PackageDescription

let package = Package(
  name: "${BINARY_NAME}",
  products: [
    .library(name: "${BINARY_NAME}", targets: ["${BINARY_NAME}Targets"])
  ],
  targets: [
    .binaryTarget(
      name: "${BINARY_NAME}",
      url: "https://github.com/${SPM_REPO}/releases/download/${tag}/${RELEASE_ZIP_NAME}",
      checksum: "${CHECKSUM}"
    ),
    .target(name: "${BINARY_NAME}Targets", dependencies: ["${BINARY_NAME}"], path: "Sources")
  ]
)
SWIFT

  if git show-ref --verify --quiet "refs/heads/${tag}"; then git checkout "${tag}"; else git checkout -b "${tag}"; fi
  git add "${PACKAGE_FILE}"
  if ! git diff --cached --quiet; then git commit -m "SPM: Update Package.swift for ${tag}"; fi
  git push "https://${GH_TOKEN}@github.com/${SPM_REPO}.git" "refs/heads/${tag}" || true
  git tag "${tag}" || true
  git push "https://${GH_TOKEN}@github.com/${SPM_REPO}.git" "refs/tags/${tag}" || true
done

echo "Package repos updated"
