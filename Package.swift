// swift-tools-version:5.8
import PackageDescription

let package = Package(
  name: "CameraSDK",
  products: [
    .library(name: "CameraSDK", targets: ["CameraSDKTargets"])
  ],
  targets: [
    .binaryTarget(
      name: "CameraSDK",
      url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/0.1.1-BETA.1/CameraSDK.xcframework.zip",
      checksum: "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    ),
    .target(name: "CameraSDKTargets", dependencies: ["CameraSDK"], path: "Sources")
  ]
)
