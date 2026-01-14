# 모듈/폴더별 역할
- `HoneyAAA/Sources/App`: 앱 엔트리, 탭 구성 (`RootTabView`)
- `HoneyAAA/Sources/Domain`: 도메인 모델, UseCase, Repository 프로토콜
- `HoneyAAA/Sources/Data`: DTO, APIClient(Mock), Repository 구현체
- `HoneyAAA/Sources/Presentation`: SwiftUI View + ViewModel + UIModel
- `Docs`: 아키텍처 및 운영 문서

## 주요 파일
- App: `HoneyAAAApp.swift`, `RootTabView.swift`
- 상대 리스트: Domain(`Opponent` 등), Data(`OpponentDetailDTO`, `RemoteOpponent...`), Presentation(`OpponentListView*`)
- 채팅 리스트/방: Domain(`ChatThread`, `ChatMessage`), Data(`ChatThreadDTO`, `RemoteChat...`), Presentation(`ChatListView*`, `ChatRoomView*`)
- 내정보: Domain(`UserProfile`), Data(`UserProfileDTO`, `RemoteUserProfileRepository`), Presentation(`MyPageView*`)

