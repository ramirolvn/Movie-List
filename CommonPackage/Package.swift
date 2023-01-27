// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonPackage",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CommonPackage",
            targets: ["CommonPackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/evgenyneu/keychain-swift.git", branch: "master"),
		.package(url: "https://github.com/realm/realm-swift", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CommonPackage",
			dependencies: [.product(name: "KeychainSwift", package: "keychain-swift"),
						   .product(name: "RealmSwift", package: "realm-swift")],
			path: "Sources"),
        .testTarget(
            name: "CommonPackageTests",
            dependencies: ["CommonPackage"]),
    ]
)
