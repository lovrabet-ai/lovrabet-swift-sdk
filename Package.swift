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
        .binaryTarget(
            name: "LovrabetSDK",
            url: "https://github.com/lovrabet-ai/lovrabet-swift-sdk/releases/download/1.0.0/LovrabetSDK-1.0.0.zip",
            checksum: "93b3fd1289998f8cc0048fbdcc0ea5fc2aecf65eac3b50a99fd0cfb713e52658"
        ),
    ]
)
