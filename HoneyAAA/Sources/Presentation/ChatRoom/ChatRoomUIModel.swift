import Foundation

/// 채팅방에 필요한 UI 모델입니다.
struct ChatMessageUIModel: Identifiable, Equatable {
    let id: String
    let text: String
    let isMine: Bool
    let timeText: String
}

extension ChatMessage {
    func toUIModel() -> ChatMessageUIModel {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return ChatMessageUIModel(
            id: id,
            text: text,
            isMine: isMine,
            timeText: formatter.string(from: sentAt)
        )
    }
}

