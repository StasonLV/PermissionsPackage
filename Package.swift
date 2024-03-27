// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PermissionsPackage",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v6)
    ],
    
    products: [
        .library(
            name: "PermissionsPackage",
            targets: ["PermissionsPackage"]
        ),
        .library(
            name: "CameraPackage",
            targets: ["CameraPackage"]
        ),
        .library(
            name: "MicPackage",
            targets: ["MicPackage"]
        ),
        .library(
            name: "FaceIDPackage",
            targets: ["FaceIDPackage"]
        ),
        .library(
            name: "NotificationPackage",
            targets: ["NotificationPackage"]
        ),
        .library(
            name: "ContactsPackage",
            targets: ["ContactsPackage"]
        ),
    ],
    
    
    targets: [
        .target(
            name: "PermissionsPackage",
            dependencies: [],
            path: "Sources/PermissionsPackage",
            swiftSettings: [
                .define("PERMISSIONSPACKAGE_SPM")
            ]
        ),
        .target(
            name: "CameraPackage",
            dependencies: [.target(name: "PermissionsPackage")],
            path: "Sources/CameraPermission",
            swiftSettings: [
                .define("PERMISSIONSPACKAGE_SPM"),
                .define("PERMISSIONSPACKAGE_CAMERA")
            ]
        ),
        .target(
            name: "MicPackage",
            dependencies: [.target(name: "PermissionsPackage")],
            path: "Sources/MicPermission",
            swiftSettings: [
                .define("PERMISSIONSPACKAGE_SPM"),
                .define("PERMISSIONSPACKAGE_MIC")
            ]
        ),
        .target(
            name: "FaceIDPackage",
            dependencies: [.target(name: "PermissionsPackage")],
            path: "Sources/FaceIDPermission",
            swiftSettings: [
                .define("PERMISSIONSPACKAGE_SPM"),
                .define("PERMISSIONSPACKAGE_FACEID")
            ]
        ),
        .target(
            name: "NotificationPackage",
            dependencies: [.target(name: "PermissionsPackage")],
            path: "Sources/NotificationPermission",
            swiftSettings: [
                .define("PERMISSIONSPACKAGE_SPM"),
                .define("PERMISSIONSPACKAGE_NOTIFICATION")
            ]
        ),
        .target(
            name: "ContactsPackage",
            dependencies: [.target(name: "PermissionsPackage")],
            path: "Sources/ContactsPermission",
            swiftSettings: [
                .define("PERMISSIONSPACKAGE_SPM"),
                .define("PERMISSIONSPACKAGE_CONTACTS")
            ]
        )
    ]
)


