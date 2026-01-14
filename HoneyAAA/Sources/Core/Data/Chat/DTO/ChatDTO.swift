import Foundation

/// 채팅 스레드 리스트 DTO 입니다.
public struct ChatThreadDTO: Codable {
    public let id: String
    public let opponentName: String
    public let lastMessage: String
    public let lastMessageAt: Date
}

/// 채팅 메시지 DTO 입니다.
public struct ChatMessageDTO: Codable, Identifiable {
    public let id: String
    public let text: String
    public let isMine: Bool
    public let sentAt: Date
}

extension ChatThreadDTO {
    public func toDomain() -> ChatThread {
        ChatThread(
            id: id,
            opponentName: opponentName,
            lastMessage: lastMessage,
            lastMessageAt: lastMessageAt
        )
    }
}

extension ChatMessageDTO {
    public func toDomain() -> ChatMessage {
        ChatMessage(
            id: id,
            text: text,
            isMine: isMine,
            sentAt: sentAt
        )
    }
}
