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
- **Data Layer**
    1) `APIClient`의 `/chats` Path에 `/chats/resend` EndPoint 추가 (Test를 위해 무조건 Error 발생)
    2) `RemoteChatMessageRepository`의 `sendMessage` 로직 수정: 메시지 내용이 "resend"일 경우 `/chats/resend` API 호출하여 실패 유도
    3) 실패한 메시지 관리를 위한 `LocalChatMessageRepository` 인터페이스 및 `LocalChatRepositories` 구현체 추가 (UserDefaults 기반)
        - `saveFailedMessage(threadId, message)`
        - `fetchFailedMessages(threadId)`
        - `removeFailedMessage(threadId, messageId)`

- **Model Layer**
    1) `ChatMessage` 모델에 `isFailed: Bool` 프로퍼티 추가

- **Presentation Layer**
    1) `ChatRoomViewModel` 수정
        - `sendMessage`: 전송 실패 시 `LocalRepository`에 저장하고 UI 상태 업데이트 (isFailed = true)
        - `resend(message)`: 재전송 로직 구현 (성공 시 Local에서 삭제)
        - `load`: `LocalRepository`에서 실패한 메시지들을 불러와 채팅 목록에 병합 표시
    2) `ChatRoomView` 수정
        - 메시지 UI에 `isFailed` 상태에 따른 "재전송" 버튼 표시
        ```swift
        if message.isFailed {
            Button {
                Task { await viewModel.resend(message: message) }
            } label: {
                Text("재전송")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        ```
