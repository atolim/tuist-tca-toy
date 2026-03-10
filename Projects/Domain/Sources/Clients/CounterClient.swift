import ComposableArchitecture
import Foundation

@DependencyClient
public struct CounterClient: Sendable {
  public var fetch: @Sendable () async throws -> CounterEntity
  public var save: @Sendable (CounterEntity) async throws -> Void
}

extension CounterClient: TestDependencyKey {
  public static let previewValue = Self(
    fetch: { CounterEntity(count: 42) },
    save: { _ in }
  )
  
  public static let testValue = Self()
}

extension DependencyValues {
  public var counterClient: CounterClient {
    get { self[CounterClient.self] }
    set { self[CounterClient.self] = newValue }
  }
}
