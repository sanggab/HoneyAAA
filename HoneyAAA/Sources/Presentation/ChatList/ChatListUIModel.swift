import Foundation

/// 채팅 리스트 셀에 필요한 UI 모델입니다.
struct ChatThreadUIModel: Identifiable, Hashable {
    let id: String
    let opponentName: String
    let lastMessage: String
    let lastMessageTime: String
}

extension ChatThread {
    func toUIModel() -> ChatThreadUIModel {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let timeText = formatter.string(from: lastMessageAt)

        return ChatThreadUIModel(
            id: id,
            opponentName: opponentName,
            lastMessage: lastMessage,
            lastMessageTime: timeText
        )
    }
}

