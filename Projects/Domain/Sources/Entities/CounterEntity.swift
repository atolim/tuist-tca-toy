import Foundation

public struct CounterEntity: Equatable {
  public var count: Int
  
  public init(count: Int = 0) {
    self.count = count
  }
}
