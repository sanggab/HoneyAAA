import Foundation

/// 채팅방에서 주고받는 메시지 도메인 모델입니다.
public struct ChatMessage: Identifiable, Equatable, Codable {
    public let id: String
    public let text: String
    public let isMine: Bool
    public let sentAt: Date

    public init(
        id: String,
        text: String,
        isMine: Bool,
        sentAt: Date
    ) {
        self.id = id
        self.text = text
        self.isMine = isMine
        self.sentAt = sentAt
    }
}

