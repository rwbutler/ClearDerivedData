// swift-tools-version:5.0
import PackageDescription

let package = Package(name: "Clear-Derived-Data")

package.platforms = [
    .macOS("10.13")
]
package.products = [
    .executable(name: "cdd", targets: ["Clear-Derived-Data"])
]
package.dependencies = [
    
]
package.targets = [
    .target(name: "Clear-Derived-Data", dependencies: [], path: "Sources")
]
