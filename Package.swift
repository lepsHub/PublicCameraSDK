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
        url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/78.2.2-RC.6/78.2.2-RC.6.xcframework.zip",
        checksum: "d78df12501bd5bea7ff5ed91e9ff4318dc6166ba82120a1373842a231cf49b56"
      ),
      .target(name: "CameraSDKTargets", dependencies: ["CameraSDK"], path: "Sources")
    ]
  )
  
