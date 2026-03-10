import ComposableArchitecture
import SwiftUI

public struct DiaryInputView: View {
  @Bindable var store: StoreOf<DiaryInputReducer>
  
  public init(store: StoreOf<DiaryInputReducer>) {
    self.store = store
  }
  
  public var body: some View {
    Form {
      Section {
        DatePicker("Date", selection: $store.date, displayedComponents: [.date])
        TextField("Title", text: $store.title)
      }
      
      Section("Content") {
        TextEditor(text: $store.content)
          .frame(minHeight: 200)
      }
    }
    .navigationTitle("New Diary")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Cancel") {
          store.send(.closeButtonTapped)
        }
      }
      ToolbarItem(placement: .confirmationAction) {
        Button("Save") {
          store.send(.saveButtonTapped)
        }
        .disabled(store.title.isEmpty || store.content.isEmpty)
      }
    }
  }
}
