// swift-tools-version:5.8

  import PackageDescription
              
  let package = Package(
    name: "CameraSDK",
    products: [
      .library(
        name: "CameraSDK",
        targets: ["CameraSDKTargets"])
    ],
    dependencies: [],
    targets: [
      .binaryTarget(
        name: "CameraSDK",
        url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/78.2.8-BETA.5/CameraSDK.xcframework.zip",
        checksum: "ddcd3070a444d0a0d758902284b58ae6d3d9a3ae0d1c163c7e6777aacab6ab3e"
      ),
      .target(
        name: "CameraSDKTargets",
        dependencies: [
          .target(name: "CameraSDK")
        ],
        path: "Sources")
    ]
  )
  
