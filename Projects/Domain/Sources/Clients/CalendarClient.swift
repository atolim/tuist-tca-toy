import ComposableArchitecture
import Foundation

@DependencyClient
public struct CalendarClient: Sendable {
  public var fetchDiaries: @Sendable (_ month: Date) async throws -> [DiaryEntity]
  public var saveDiary: @Sendable (DiaryEntity) async throws -> Void
}

extension CalendarClient: TestDependencyKey {
  public static let previewValue = Self(
    fetchDiaries: { _ in
      [
        DiaryEntity(date: Date(), title: "Sample Diary", content: "This is a preview diary."),
        DiaryEntity(date: Date().addingTimeInterval(86400), title: "Tomorrow", content: "Another day.")
      ]
    },
    saveDiary: { _ in }
  )
  
  public static let testValue = Self()
}

extension DependencyValues {
  public var calendarClient: CalendarClient {
    get { self[CalendarClient.self] }
    set { self[CalendarClient.self] = newValue }
  }
}
