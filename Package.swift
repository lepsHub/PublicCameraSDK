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
        url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/78.2.2-BETA.8/78.2.2-BETA.8.xcframework.zip",
        checksum: "7404d5cb162992b6ee1a0fe12aae008ae0ce85755fc0cbed4ef94ea0e4b978f3"
      ),
      .target(name: "CameraSDKTargets", dependencies: ["CameraSDK"], path: "Sources")
    ]
  )
  
