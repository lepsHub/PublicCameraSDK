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
        url: "https://github.com/lepsHub/PublicCameraSDK/releases/download/78.2.2-RC.9/CameraSDK.xcframework.zip",
        checksum: "2f2a29d01b0ec51c2032bfffc41df2d1268e63bf4c1172791a1118e4d53ab1dc"
      ),
      .target(name: "CameraSDKTargets", dependencies: ["CameraSDK"], path: "Sources")
    ]
  )
  
