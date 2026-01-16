import Foundation

public protocol ChatMessageRepository {
//    func fetchMessages(threadId: String) async throws -> [ChatMessage]
//    func sendMessage(threadId: String, text: String) async throws -> ChatMessage
//    func fetchResendMessage(threadId: String) throws -> [ChatMessage]
//    /// 시나리오 테스트용
//    func sendFailedMessage(threadId: String, text: String) async throws
//    func sendResendmessage(threadId: String, text: String, id: String) async throws -> ChatMessage
    
//    func fetchMessages(input: ) async throws -> [ChatMessage]
//    func sendMessage(threadId: String, text: String) async throws -> ChatMessage
//    func fetchResendMessage(threadId: String) throws -> [ChatMessage]
//    /// 시나리오 테스트용
//    func sendFailedMessage(threadId: String, text: String) async throws
//    func sendResendmessage(threadId: String, text: String, id: String) async throws -> ChatMessage
}

public struct DefaultChatMessageRepository: ChatMessageRepository {
    private let remote: RemoteChatMessageRepository
    private let local: LocalChatMessageRepository
    
    public init(remote: RemoteChatMessageRepository, local: LocalChatMessageRepository) {
        self.remote = remote
        self.local = local
    }
}
