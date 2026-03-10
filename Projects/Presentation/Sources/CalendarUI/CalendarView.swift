import ComposableArchitecture
import Domain
import SwiftUI

public struct CalendarView: View {
  @Bindable var store: StoreOf<CalendarReducer>
  
  public init(store: StoreOf<CalendarReducer>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      ZStack(alignment: .bottomTrailing) {
        VStack {
          if store.isCalendarExpanded {
            DatePicker(
              "Select Date",
              selection: $store.selectedDate,
              displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
          } else {
            WeekCalendarView(selectedDate: $store.selectedDate)
              .padding()
          }
          
          Button {
            store.send(.toggleCalendarExpanded)
          } label: {
            Image(systemName: store.isCalendarExpanded ? "chevron.up" : "chevron.down")
              .foregroundColor(.secondary)
              .padding(.bottom, 8)
          }
          
          List {
            ForEach(store.diaries) { diary in
              VStack(alignment: .leading) {
                Text(diary.title)
                  .font(.headline)
                  .lineLimit(2)
                Text(diary.content)
                  .font(.subheadline)
                  .foregroundColor(.secondary)
                  .lineLimit(2)
              }
            }
          }
        }
        
        Button {
          store.send(.floatingButtonTapped)
        } label: {
          Image(systemName: "plus")
            .font(.title.bold())
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(radius: 4)
        }
        .padding()
      }
      .navigationTitle("Diary")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear {
        store.send(.fetchDiaries)
      }
      .fullScreenCover(item: $store.scope(state: \.destination?.diaryInput, action: \.destination.diaryInput)) { store in
        NavigationStack {
          DiaryInputView(store: store)
        }
      }
    }
  }
}

struct WeekCalendarView: View {
  @Binding var selectedDate: Date
  
  private var currentWeek: [Date] {
    var calendar = Calendar.current
    calendar.firstWeekday = 1 // Sunday
    
    let today = calendar.startOfDay(for: selectedDate)
    guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else { return [] }
    
    return (0..<7).compactMap { days in
      calendar.date(byAdding: .day, value: days, to: weekInterval.start)
    }
  }
  
  var body: some View {
    VStack {
      HStack {
        Text(selectedDate.formatted(.dateTime.year().month()))
          .font(.headline)
        Spacer()
      }
      .padding(.horizontal)
      
      HStack(spacing: 0) {
        ForEach(currentWeek, id: \.self) { date in
          VStack(spacing: 8) {
            Text(date.formatted(.dateTime.weekday(.narrow)))
              .font(.caption)
              .foregroundColor(.secondary)
            
            Text(date.formatted(.dateTime.day()))
              .font(.subheadline)
              .fontWeight(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? .bold : .regular)
              .foregroundColor(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? .white : .primary)
              .frame(width: 32, height: 32)
              .background(
                Circle()
                  .fill(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.blue : Color.clear)
              )
          }
          .frame(maxWidth: .infinity)
          .contentShape(Rectangle())
          .onTapGesture {
            selectedDate = date
          }
        }
      }
    }
  }
}
