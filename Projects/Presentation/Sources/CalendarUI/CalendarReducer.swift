import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct CalendarReducer {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var diaries: [DiaryEntity] = []
    public var selectedDate: Date = Date()
    public var isCalendarExpanded: Bool = false
    @Presents public var destination: Destination.State?
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case toggleCalendarExpanded
    case fetchDiaries
    case diariesResponse(Result<[DiaryEntity], Swift.Error>)
    case floatingButtonTapped
    case destination(PresentationAction<Destination.Action>)
  }
  
  @Reducer(state: .equatable)
  public enum Destination {
    case diaryInput(DiaryInputReducer)
  }
  
  @Dependency(\.calendarClient) var calendarClient
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .toggleCalendarExpanded:
        state.isCalendarExpanded.toggle()
        return .none
        
      case .fetchDiaries:
        return .run { [date = state.selectedDate] send in
          await send(.diariesResponse(Result { try await calendarClient.fetchDiaries(date) }))
        }
        
      case let .diariesResponse(.success(diaries)):
        state.diaries = diaries
        return .none
        
      case .diariesResponse(.failure):
        // Handle error logging
        return .none
        
      case .floatingButtonTapped:
        state.destination = .diaryInput(DiaryInputReducer.State(date: state.selectedDate))
        return .none
        
      case .destination(.presented(.diaryInput(.delegate(.diarySaved)))):
        state.destination = nil
        return .send(.fetchDiaries)
        
      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}
