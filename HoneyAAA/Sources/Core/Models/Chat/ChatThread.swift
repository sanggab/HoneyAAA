import Foundation

/// 채팅 스레드(리스트 화면) 도메인 모델입니다.
public struct ChatThread: Identifiable, Equatable {
    public let id: String
    public let opponentName: String
    public let lastMessage: String
    public let lastMessageAt: Date

    public init(
        id: String,
        opponentName: String,
        lastMessage: String,
        lastMessageAt: Date
    ) {
        self.id = id
        self.opponentName = opponentName
        self.lastMessage = lastMessage
        self.lastMessageAt = lastMessageAt
    }
}

