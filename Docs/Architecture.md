# 아키텍처 개요
- 기술 스택: SwiftUI + MVVM, Tuist
- 레이어드 구조: Presentation → Domain → Data (또는 Presentation → Data 직결 가능하지만 본 예제는 Domain을 기본 경로로 사용)
- DTO(APIModel) → Domain Model → UI Model 변환 단계를 명시적으로 유지해 API 변경 시 영향을 최소화

## 레이어 책임
- Presentation: View, ViewModel, UIModel. 상태 관리 및 UI 변환 담당.
- Domain: 비즈니스 규칙, UseCase, Repository Protocol, Domain Model.
- Data: 네트워크/캐시/DB 구현, DTO 정의, Repository 구현체. DTO → Domain 변환.

## 주요 흐름 예시
- 상대 리스트: ViewModel → GetOpponentListUseCase → OpponentListRepository + OpponentDetailRepository → DTO → Domain → UIModel → View
- 채팅: ChatListViewModel → GetChatThreadsUseCase → ChatThreadRepository → DTO → Domain → UIModel
- 내정보: MyPageViewModel → Get/UpdateUserProfileUseCase → UserProfileRepository → DTO → Domain → UIModel

## 모듈/폴더 구조
- App: RootTabView, App Entry
- Domain: Feature별 Model/Repository/UseCase
- Data: Core(APIClient), Feature별 DTO/Repository 구현
- Presentation: Feature별 UIModel/ViewModel/View
- Docs: 문서 정리

