// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "MethodNotificationCenter",

    platforms: [
        .iOS("11.0"),
        .macOS("10.10"),
        .tvOS("9.0")
    ],

    products: [
        .library(name: "MethodNotificationCenter", targets: ["MethodNotificationCenter"]),
    ],

    targets: [
        .target(name: "MethodNotificationCenter"),
        .testTarget(name: "MethodNotificationCenterObjCTests", dependencies: ["MethodNotificationCenter"]),
        .testTarget(name: "MethodNotificationCenterSwiftTests", dependencies: ["MethodNotificationCenter"])
    ]
)
