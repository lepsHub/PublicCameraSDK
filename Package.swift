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
        url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/78.2.2-RC.5/78.2.2-RC.5.xcframework.zip",
        checksum: "b4924672c0ecafaa14197498f676a6f1396ff8917534dc253cd35ef177161ef8"
      ),
      .target(name: "CameraSDKTargets", dependencies: ["CameraSDK"], path: "Sources")
    ]
  )
  
