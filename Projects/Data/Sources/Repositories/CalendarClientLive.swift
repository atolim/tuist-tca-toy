import ComposableArchitecture
import Domain
import Foundation

extension CalendarClient: @retroactive DependencyKey {
  public static var list: [DiaryEntity] = []
  
  public static let liveValue = Self(
    fetchDiaries: { _ in 
      // In a real app, this would fetch from a database or API
      // For now, we return an empty array or some mock data if needed
      return list
    },
    saveDiary: { diary in
      list.insert(diary, at: 0)
      // In a real app, this would save to a database or API
      print("Diary saved: \(diary.title)")
    }
  )
}
