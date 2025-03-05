// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Arrival–GTFS",
    platforms: [
          
           .iOS(.v15),
           .macOS(.v13)
       ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Arrival–GTFS",
            targets: ["Arrival–GTFS"]),
    ],
    dependencies: [
      // .package(url: "https://github.com/marmelroy/Zip.git", .upToNextMajor(from: "2.1.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Arrival–GTFS"
          //  dependencies: ["Zip"]
        ),
        
        .testTarget(
            name: "Arrival–GTFS-2Tests",
            dependencies: ["Arrival–GTFS"]
        ),
    ]
)
