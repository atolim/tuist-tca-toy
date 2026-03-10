import ProjectDescription

let project = Project(
  name: "TuistTCAToy",
  targets: [
    // App Layer
    .target(
      name: "TuistTCAToy",
      destinations: .iOS,
      product: .app,
      bundleId: "io.tuist.TuistTCAToy",
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
        ]
      ),
      sources: ["Projects/App/Sources/**"],
      resources: ["Projects/App/Resources/**"],
      dependencies: [
        .target(name: "Presentation"),
        .target(name: "Data"),
        .target(name: "Domain"),
        .target(name: "Core"),
      ]
    ),
    // Presentation Layer (TCA Features)
    .target(
      name: "Presentation",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Presentation",
      sources: ["Projects/Presentation/Sources/**"],
      dependencies: [
        .target(name: "Domain"),
        .target(name: "Core"),
        .external(name: "ComposableArchitecture")
      ]
    ),
    // Domain Layer (Business Logic + Interfaces)
    .target(
      name: "Domain",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Domain",
      sources: ["Projects/Domain/Sources/**"],
      dependencies: [
        .external(name: "ComposableArchitecture")
      ]
    ),
    // Data Layer (Infrastructure)
    .target(
      name: "Data",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Data",
      sources: ["Projects/Data/Sources/**"],
      dependencies: [
        .target(name: "Domain"),
        .target(name: "Core")
      ]
    ),
    // Core Layer (Shared)
    .target(
      name: "Core",
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "io.tuist.Core",
      sources: ["Projects/Core/Sources/**"],
      dependencies: []
    ),
  ]
)
