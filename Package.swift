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
        url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/78.2.15/CameraSDK.xcframework.zip",
        checksum: "cee48ab7bb881f7a6bd88b629207dc0a1893b239f25bb4f487fd4d9ab76a1701"
      ),
      .target(
        name: "CameraSDKTargets",
        dependencies: [
          .target(name: "CameraSDK")
        ],
        path: "Sources")
    ]
  )
  
