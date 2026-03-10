import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct DiaryInputReducer {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var date: Date
    public var title: String = ""
    public var content: String = ""
    
    public init(date: Date) {
      self.date = date
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case saveButtonTapped
    case saveResponse(Result<Void, Swift.Error>)
    case closeButtonTapped
    case delegate(Delegate)
    
    public enum Delegate {
      case diarySaved
    }
  }
  
  @Dependency(\.calendarClient) private var calendarClient
  @Dependency(\.dismiss) private var dismiss
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .saveButtonTapped:
        let newDiary = DiaryEntity(date: state.date, title: state.title, content: state.content)
        return .run { send in
          await send(.saveResponse(Result { try await calendarClient.saveDiary(newDiary) }))
        }
        
      case .saveResponse(.success):
        return .run { send in
          await send(.delegate(.diarySaved))
          await dismiss()
        }
        
      case .saveResponse(.failure):
        // handle error
        return .none
        
      case .closeButtonTapped:
        return .run { _ in await dismiss() }
        
      case .delegate:
        return .none
      }
    }
  }
}
