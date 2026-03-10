import Foundation
import Domain

// MARK: - DiaryDTO
struct DiaryDTO: Codable {
  let id: String   // UUID string
  let date: String // "yyyy-MM-dd"
  let title: String
  let content: String

  private static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()

  func toDomain() -> DiaryEntity {
    let parsedDate = Self.dateFormatter.date(from: date) ?? Date()
    return DiaryEntity(
      id: UUID(uuidString: id) ?? UUID(),
      date: parsedDate,
      title: title,
      content: content
    )
  }

  static func from(entity: DiaryEntity) -> DiaryDTO {
    DiaryDTO(
      id: entity.id.uuidString,
      date: dateFormatter.string(from: entity.date),
      title: entity.title,
      content: entity.content
    )
  }
}
