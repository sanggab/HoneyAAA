# API 변경/추가 시나리오와 클린 아키텍처 비교

## 시나리오 1: 채팅 리스트 상대 프로필 이미지 URL Response 필드 추가
- Data: `ChatThreadDTO`에 `profileImageURL: String` 필드 추가 → `toDomain()`에서 URL 변환
- Model: 필요 시 `ChatThread`에 `profileImageURL` 필드 추가
- Presentation: `ChatThreadUIModel`에 표시 여부 결정 (없는 경우 UI 기본값 처리)

## 시나리오 2: 채팅방에 채팅 읽음 API 추가 및 읽음 상태(isRead) 필드 추가
- Data: 1) `APIClient`의 `/chats` Path에 `/chats/readAll` EndPoint 추가 (반환 값 없음)
        2) `ChatMessageRepository`에 `readAll()` 함수 추가
        3) `ChatMessageDTO`에 `isRead` 추가, `toDomain()` 변환
- Model: `ChatMessage`에 `isRead` 추가
- Presentation: `ChatMessageUIModel`에 'isRead' 추가

## 시나리오 3: 전송에 실패한 채팅 메세지를 로컬에 저장하고, 재전송 하는 기능 추가
