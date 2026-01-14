import Foundation

/// 채팅 스레드 리스트를 제공하는 레포지토리입니다.
public protocol ChatThreadRepository {
    func fetchThreads() async throws -> [ChatThread]
}

/// 채팅방 메시지 목록을 제공하는 레포지토리입니다.
public protocol ChatMessageRepository {
    func fetchMessages(threadId: String) async throws -> [ChatMessage]
    func sendMessage(threadId: String, text: String) async throws -> ChatMessage
}

