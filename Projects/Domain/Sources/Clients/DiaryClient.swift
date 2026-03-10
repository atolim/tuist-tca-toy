import ComposableArchitecture
import Foundation

@DependencyClient
public struct DiaryClient: Sendable {
  public var createDiary: @Sendable (_ date: Date, _ title: String, _ content: String) async throws -> DiaryEntity
  public var deleteDiary: @Sendable (_ id: String) async throws -> Void
  public var fetchDiaries: @Sendable (_ date: Date) async throws -> [DiaryEntity]
  public var updateDiary: @Sendable (_ id: String, _ date: Date, _ title: String, _ content: String) async throws -> DiaryEntity
}

extension DiaryClient: TestDependencyKey {
  public static let previewValue = Self(
    createDiary: { date, title, content in
      DiaryEntity(date: date, title: title, content: content)
    },
    deleteDiary: { _ in },
    fetchDiaries: { _ in
      [
        DiaryEntity(date: Date(), title: "Sample Diary", content: "This is a preview diary."),
        DiaryEntity(date: Date().addingTimeInterval(86400), title: "Tomorrow", content: "Another day.")
      ]
    },
    updateDiary: { _, date, title, content in
      DiaryEntity(date: date, title: title, content: content)
    }
  )

  public static let testValue = Self()
}

extension DependencyValues {
  public var diaryClient: DiaryClient {
    get { self[DiaryClient.self] }
    set { self[DiaryClient.self] = newValue }
  }
}
