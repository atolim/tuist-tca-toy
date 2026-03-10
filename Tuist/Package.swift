// swift-tools-version: 5.9
import PackageDescription

#if TUIST
  import ProjectDescription

  let packageSettings = PackageSettings(
    productTypes: [
      "ComposableArchitecture": .framework,
      "Alamofire": .framework,
    ]
  )
#endif

let package = Package(
  name: "TuistTCAToy",
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.0"),
    .package(url: "https://github.com/Alamofire/Alamofire", from: "5.9.0"),
  ]
)
// In some cases, the product names need to be listed if they differ from the package name.
// But pointfreeco/swift-composable-architecture has ComposableArchitecture as a product.
