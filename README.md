# Tuist TCA Toy Project

이 프로젝트는 **Tuist**와 **The Composable Architecture (TCA)**를 활용하여 구성된 모듈화 장난감(Toy) 프로젝트입니다. 앱의 확장성과 유지보수성을 높이기 위해 명확한 계층 분리(레이어드 아키텍처)와 모듈화를 지향합니다.

## 🏗️ 모듈 구조 및 역할 (Modular Architecture)

본 프로젝트는 의존성 방향이 단방향으로 흐르도록 설계되었습니다. (단위 모듈들이 `App` 타겟을 향해 결합됩니다.)

### 1. **App 모듈 (`Projects/App`)**
- **역할:** 앱의 진입점(Entry Point) 및 최상위 컴포지션(Composition) 계층입니다.
- **특징:** 모든 개별 모듈(Feature, Data 등)을 조립하여 실제 앱을 구동합니다. 구체적인 비즈니스 로직이나 UI 구성 요소를 직접 가지지 않고 모듈들을 연결하는 역할만 수행합니다.

### 2. **Presentation 모듈 (`Projects/Presentation`)**
- **역할:** 사용자에게 보여지는 UI 및 Feature 로직을 담당합니다.
- **특징:** 
  - `SwiftUI` 뷰와 TCA의 `Reducer`가 함께 위치합니다.
  - 각 화면이나 도메인별로 구분되어 있으며, 필요에 따라 개별 피처 모듈로 분리할 수 있습니다.
  - **의존성:** `Domain` 계층에 의존하여 비즈니스 로직(Client)을 호출합니다.

### 3. **Domain 모듈 (`Projects/Domain`)**
- **역할:** 앱의 핵심 비즈니스 규칙과 모델 인터페이스가 위치하는 순수 도메인 계층입니다.
- **특징:**
  - `Entities`: 앱 내에서 통용되는 순수 데이터 모델.
  - `Clients (Interfaces)`: 외부 시스템(API, DB 등)과 통신하기 위한 인터페이스 (`@DependencyClient` 등 활용). 프레임워크나 외부 라이브러리(Alamofire 등)에 직접 의존하지 않습니다.
  - **이 모듈은 다른 레이어(`Presentation`, `Data`)들이 바라보는 중심점** 역할을 하며, 가장 독립적이어야 합니다.

### 4. **Data 모듈 (`Projects/Data`)**
- **역할:** `Domain` 계층에서 정의한 인터페이스(`Client`)의 실제 구현체(Live Implementation)를 제공합니다.
- **특징:**
  - 네트워크 통신, 로컬 DB 접근 등의 구체적인 작업이 이루어집니다.
  - 외부 서버나 DB의 스키마에 맞는 `DTO (Data Transfer Object)`를 정의하고, 도메인 `Entity`로 변환(Mapping)하는 책임을 가집니다.
  - **의존성:** `Domain` 모듈의 인터페이스를 채택하여 구현하기 위해 `Domain`에 의존합니다.

### 5. **Core 모듈 (`Projects/Core`)**
- **역할:** 프로젝트 전반에서 공통으로 사용되는 기반 유틸리티나 설정들을 모아둔 모듈입니다.
- **특징:** 특정 도메인에 종속되지 않는 공통 UI 컴포넌트, Foundation 확장(Extensions), Logging 시스템, 디자인 시스템 등을 포함합니다.

---

## 🔄 의존성 흐름 (Dependency Flow)

1. `App` ➡️ `Presentation`, `Data`, `Domain` (모든 것을 조립)
2. `Presentation` ➡️ `Domain` (인터페이스를 통해 로직 호출 및 모델 사용)
3. `Data` ➡️ `Domain` (인터페이스의 실제 구현 제공 및 모델 매핑)
4. (`Presentation`, `Data`, `Domain`) ➡️ `Core` (필요시 공통 유틸리티 사용)

- `Presentation`과 `Data`는 서로를 직접 알지 못하며, 오직 `Domain`이라는 인터페이스(추상화)를 통해서만 연결됩니다. 이를 통해 코드의 결합도를 낮추고 테스트 용이성을 극대화합니다.

---

## 🛠️ 기술 스택 (Tech Stack)

- **Architecture:** The Composable Architecture (TCA)
- **Project Generation:** Tuist
- **UI:** SwiftUI
- **Language:** Swift

## 🚀 시작하기 (Getting Started)

의존성을 받아오고 프로젝트(Xcode workspace)를 생성하려면 다음 명령어를 사용하세요.

```bash
# Tuist 의존성 설치 (필요시)
tuist install

# Xcode 프로젝트 및 워크스페이스 생성
tuist generate
```
