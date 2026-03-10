import ComposableArchitecture
import Core
import Domain
import Foundation

public final class CounterRepositoryImpl {
  private var currentDTO = CounterDTO(count: 0)
  private let logger: any Logger
  
  public init(logger: any Logger = SimpleLogger()) {
    self.logger = logger
  }
  
  public func fetchCount() async throws -> CounterEntity {
    logger.log("Repository: Fetching DTO", level: .debug)
    // Simulate DTO to Entity mapping
    return CounterEntity(count: currentDTO.count)
  }
  
  public func saveCount(_ entity: CounterEntity) async throws {
    // Map Entity to DTO
    currentDTO = CounterDTO(count: entity.count, lastUpdated: Date())
    logger.log("Repository: Saved DTO (count: \(currentDTO.count))", level: .info)
  }
}

extension CounterClient: DependencyKey {
  public static let liveValue: Self = {
    let repository = CounterRepositoryImpl()
    return Self(
      fetch: { try await repository.fetchCount() },
      save: { try await repository.saveCount($0) }
    )
  }()
}