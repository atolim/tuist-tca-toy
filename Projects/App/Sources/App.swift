import ComposableArchitecture
import Presentation
import Data
import Domain
import SwiftUI

@main
struct TuistTCAToyApp: App {
  init() {
    // Dependency Injection / Assembly
    prepareDependencies()
  }
  
  func prepareDependencies() {
    // Initialization logic if needed
  }
  
  static let store = Store(initialState: CounterFeature.State()) {
    CounterFeature()
  } withDependencies: {
    #if DEBUG
    $0.counterClient = .liveValue
    #else
    $0.counterClient = .remote
    #endif
  }
  
  var body: some Scene {
    WindowGroup {
      CounterView(store: Self.store)
    }
  }
}
