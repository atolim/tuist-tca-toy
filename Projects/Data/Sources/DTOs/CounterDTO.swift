import Foundation

public struct CounterDTO: Codable, Sendable {
  public let count: Int
  public let lastUpdated: Date
  
  public init(count: Int, lastUpdated: Date = Date()) {
    self.count = count
    self.lastUpdated = lastUpdated
  }
}
