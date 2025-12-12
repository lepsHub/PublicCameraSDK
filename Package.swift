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
        url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/78.2.14/CameraSDK.xcframework.zip",
        checksum: "a3c177d183cc1b9c32600bec13f2955954fc9c1d54b0206c536ce5b9c6ddd390"
      ),
      .target(
        name: "CameraSDKTargets",
        dependencies: [
          .target(name: "CameraSDK")
        ],
        path: "Sources")
    ]
  )
  
