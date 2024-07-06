// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlaygroundDependencies",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PlaygroundDependencies",
            targets: ["PlaygroundDependencies"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PlaygroundDependencies"),
        .testTarget(
            name: "PlaygroundDependenciesTests",
            dependencies: ["PlaygroundDependencies"]),
    ]
)

package.dependencies = [
    .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.7.1")
]
package.targets = [
    .target(name: "PlaygroundDependencies",
        dependencies: [
            .product(name: "RxSwift", package: "RxSwift")
        ]
    )
]
package.platforms = [
    .iOS("9.0"),
    .macOS("10.10"),
    .tvOS("9.0"),
    .watchOS("3.0")
]