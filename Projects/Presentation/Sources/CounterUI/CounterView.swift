import ComposableArchitecture
import SwiftUI

public struct CounterView: View {
  public let store: StoreOf<CounterFeature>
  
  public init(store: StoreOf<CounterFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      // Background Gradient
      LinearGradient(
        colors: [Color(white: 0.1), Color(white: 0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()
      
      VStack(spacing: 40) {
        headerView
        
        ZStack {
          if store.isLoading {
            ProgressView()
              .scaleEffect(1.5)
              .tint(.white)
          } else {
            counterCard
          }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        
        ControlButtons(
          onDecrement: { store.send(.decrementButtonTapped) },
          onIncrement: { store.send(.incrementButtonTapped) }
        )
      }
      .padding(24)
    }
    .onAppear { store.send(.onAppear) }
  }
  
  private var headerView: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("TCA Toy Project")
        .font(.system(size: 14, weight: .bold))
        .foregroundColor(.blue)
        .tracking(2)
      
      Text("Modern Counter")
        .font(.system(size: 32, weight: .black))
        .foregroundColor(.white)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var counterCard: some View {
    VStack {
      Text("\(store.count)")
        .font(.system(size: 100, weight: .heavy, design: .monospaced))
        .foregroundColor(.white)
        .contentTransition(.numericText(value: Double(store.count)))
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: store.count)
      
      Text("CURRENT COUNT")
        .font(.system(size: 12, weight: .bold))
        .foregroundColor(.white.opacity(0.6))
        .tracking(4)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      RoundedRectangle(cornerRadius: 32)
        .fill(.white.opacity(0.05))
        .background(.ultraThinMaterial)
        .overlay {
          RoundedRectangle(cornerRadius: 32)
            .stroke(.white.opacity(0.1), lineWidth: 1)
        }
    }
    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
  }
}

private struct CountLabel: View {
  let count: Int
  
  var body: some View {
    Text("\(count)")
      .font(.system(size: 80, weight: .bold, design: .monospaced))
  }
}

private struct ControlButtons: View {
  let onDecrement: () -> Void
  let onIncrement: () -> Void
  
  var body: some View {
    HStack(spacing: 20) {
      Button(action: onDecrement) {
        buttonContent(systemName: "minus", color: .red)
      }
      
      Button(action: onIncrement) {
        buttonContent(systemName: "plus", color: .green)
      }
    }
  }
  
  private func buttonContent(systemName: String, color: Color) -> some View {
    Image(systemName: systemName)
      .font(.system(size: 24, weight: .bold))
      .foregroundColor(.white)
      .frame(maxWidth: .infinity)
      .frame(height: 64)
      .background {
        RoundedRectangle(cornerRadius: 20)
          .fill(color.opacity(0.2))
          .overlay {
            RoundedRectangle(cornerRadius: 20)
              .stroke(color.opacity(0.3), lineWidth: 1)
          }
      }
  }
}
