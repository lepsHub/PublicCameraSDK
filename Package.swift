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
        url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/78.2.8-BETA.3/CameraSDK.xcframework.zip",
        checksum: "64b93aba380baae2e7414cf59d554f85063e5276cb4444dbd09467cf73c85452"
      ),
      .target(
        name: "CameraSDKTargets",
        dependencies: [
          .target(name: "CameraSDK")
        ],
        path: "Sources")
    ]
  )
  
