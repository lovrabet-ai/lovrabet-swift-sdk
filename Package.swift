// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "LovrabetSDK",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "LovrabetSDK",
            targets: ["LovrabetSDK"]
        ),
    ],
    targets: [
        // 二进制分发 - 通过 GitHub Releases 下载预编译的 XCFramework
        .binaryTarget(
            name: "LovrabetSDK",
            url: "https://github.com/lovrabet-ai/lovrabet-swift-sdk/releases/download/1.0.0/LovrabetSDK-1.0.0.zip",
            checksum: "PLACEHOLDER_CHECKSUM"
        ),
    ]
)
