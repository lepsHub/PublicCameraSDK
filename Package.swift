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
      url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/0.0.3-BETA.2/0.0.3-BETA.2-cam.xcframework.zip",
      checksum: "41b7586c8a83ec95e479414f0ab494823e30e789ab8beafb4b3065304f58140e"
    ),
    .target(name: "CameraSDKTargets", dependencies: ["CameraSDK"], path: "Sources")
  ]
)
