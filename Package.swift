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
        url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/78.2.16-BETA.1/CameraSDK.xcframework.zip",
        checksum: "3ae7aeb371570c8997e792f8c67eb2a28fdaf1ce1387ff8b4683c66555be7f0b"
      ),
      .target(
        name: "CameraSDKTargets",
        dependencies: [
          .target(name: "CameraSDK")
        ],
        path: "Sources")
    ]
  )
  
