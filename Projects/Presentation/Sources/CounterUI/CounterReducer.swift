import ComposableArchitecture
import Core
import Domain
import Foundation

@Reducer
public struct CounterFeature {
  @ObservableState
  public struct State: Equatable {
    public var count = 0
    public var isLoading = false
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case onAppear
    case fetchResponse(Result<CounterEntity, Error>)
    case decrementButtonTapped
    case incrementButtonTapped
    case saveResponse(Result<Void, Error>)
  }
  
  @Dependency(\.counterClient) var counterClient
  @Dependency(\.logger) var logger
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onAppear:
        logger.log("CounterView onAppear", level: .debug)
        state.isLoading = true
        return .run { send in
          await send(.fetchResponse(Result { try await counterClient.fetch() }))
        }
        
      case let .fetchResponse(.success(entity)):
        logger.log("Fetched count: \(entity.count)", level: .info)
        state.isLoading = false
        state.count = entity.count
        return .none
        
      case let .fetchResponse(.failure(error)):
        logger.log("Failed to fetch count: \(error)", level: .error)
        state.isLoading = false
        return .none
        
      case .decrementButtonTapped:
        state.count -= 1
        logger.log("Decrement tapped, new count: \(state.count)", level: .debug)
        return .run { [count = state.count] send in
          await send(.saveResponse(Result { try await counterClient.save(CounterEntity(count: count)) }))
        }
        
      case .incrementButtonTapped:
        state.count += 1
        logger.log("Increment tapped, new count: \(state.count)", level: .debug)
        return .run { [count = state.count] send in
          await send(.saveResponse(Result { try await counterClient.save(CounterEntity(count: count)) }))
        }
        
      case let .saveResponse(.failure(error)):
        logger.log("Failed to save count: \(error)", level: .error)
        return .none
        
      case .saveResponse(.success):
        logger.log("Successfully saved count", level: .debug)
        return .none
      }
    }
  }
}

// MARK: - Dependencies

extension DependencyValues {
  public var logger: any Logger {
    get { self[LoggerKey.self] }
    set { self[LoggerKey.self] = newValue }
  }
  
  private enum LoggerKey: DependencyKey {
    static let liveValue: any Logger = SimpleLogger()
    static let testValue: any Logger = SimpleLogger()
  }
}
