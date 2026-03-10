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
      deploymentTargets: .iOS("18.0"),
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
      deploymentTargets: .iOS("18.0"),
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
      deploymentTargets: .iOS("18.0"),
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
      deploymentTargets: .iOS("18.0"),
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
      deploymentTargets: .iOS("18.0"),
      sources: ["Projects/Core/Sources/**"],
      dependencies: []
    ),
  ]
)
