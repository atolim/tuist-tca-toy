---
name: TCA Development
description: Guidelines and patterns for developing with The Composable Architecture, SwiftUI, and Tuist.
---

# TCA Development Skill

## Core Stack

- **Language:** Swift 5.9+
- **Framework:** SwiftUI, TCA (v1.x+)
- **Dependency Management:** Tuist (Project.swift 기반 모듈화)

## Implementation Patterns

### Dependency Client 정의 (Domain)

클라이언트 인터페이스는 Domain 레이어에서 `@DependencyClient` 매크로를 사용하여 정의합니다.

```swift
@DependencyClient
struct UnsplashClient {
    var searchPhotos: @Sendable (String) async throws -> [Photo]
}
```

### Dependency Injection (TCA)

Reducer 내부에서 `@Dependency`를 사용하여 필요한 클라이언트를 주입받습니다.

```swift
@Reducer
struct MyFeature {
    @Dependency(\.unsplashClient) var unsplashClient
    // ...
}
```

## Layering Strategy

1. **Domain**: 비즈니스 로직과 인터페이스 (의존성 최소화).
2. **Data**: API 통신, DTO 매핑, 클라이언트의 실제 구현체 (LiveValue).
3. **Presentation (FeatureUI)**: SwiftUI View와 Reducer.
   **Presentation/CounterUI**
   **Presentation/CounterUI/CounterReducer.swift**
   **Presentation/CounterUI/CounterView.swift**
4. **Core**: 공통 로직 및 유틸리티.
