import ComposableArchitecture
import Core
import Domain
import Foundation

/// A production-ready repository implementation that would normally fetch data from a Remote API.
public final class RemoteCounterRepositoryImpl {
  private let logger: any Logger
  
  public init(logger: any Logger = SimpleLogger()) {
    self.logger = logger
  }
  
  public func fetchCount() async throws -> CounterEntity {
    logger.log("Remote: Fetching from API...", level: .debug)
    try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
    // Simulate DTO from API
    let dto = CounterDTO(count: 100)
    return CounterEntity(count: dto.count)
  }
  
  public func saveCount(_ entity: CounterEntity) async throws {
    // Map Entity to DTO for API
    let _ = CounterDTO(count: entity.count)
    logger.log("Remote: Saving count to API: \(entity.count)", level: .info)
    try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
  }
}

extension CounterClient {
  public static let remote = {
    let repository = RemoteCounterRepositoryImpl()
    return Self(
      fetch: { try await repository.fetchCount() },
      save: { try await repository.saveCount($0) }
    )
  }()
}
