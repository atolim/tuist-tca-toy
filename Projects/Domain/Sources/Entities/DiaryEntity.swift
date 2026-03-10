import Foundation

public struct DiaryEntity: Equatable, Identifiable {
  public let id: String
  public var date: Date
  public var title: String
  public var content: String
  
  public init(id: String = UUID().uuidString, date: Date, title: String, content: String) {
    self.id = id
    self.date = date
    self.title = title
    self.content = content
  }
}
