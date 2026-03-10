import ComposableArchitecture
import Presentation
import Data
import Domain
import SwiftUI

@main
struct TuistTCAToyApp: App {
  static let store = Store(initialState: CalendarReducer.State()) {
    CalendarReducer()
  } withDependencies: {
    $0.calendarClient = CalendarClient.liveValue
  }
  
  var body: some Scene {
    WindowGroup {
      CalendarView(store: Self.store)
    }
  }
}
