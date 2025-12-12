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
        url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/78.2.5/CameraSDK.xcframework.zip",
        checksum: "ee3031627b82803255bde9ff8a4e781e463c8be80ac8a5187333f88a0bfa7b84"
      ),
      .target(name: "CameraSDKTargets", dependencies: ["CameraSDK"], path: "Sources")
    ]
  )
  
