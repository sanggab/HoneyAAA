import Foundation

/// 채팅 스레드 리스트를 제공하는 레포지토리입니다.
public protocol ChatThreadRepository {
    func fetchThreads() async throws -> [ChatThread]
}

/// 채팅 스레드/메시지 레포지토리의 원격 구현체입니다.
public final class RemoteChatThreadRepository: ChatThreadRepository {
    private let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func fetchThreads() async throws -> [ChatThread] {
        let dto = try await apiClient.request(Endpoint(path: "/chats/threads"), as: [ChatThreadDTO].self)
        return dto.map { $0.toDomain() }
    }
}

/// 채팅방 메시지 목록을 제공하는 레포지토리입니다.
public protocol RemoteChatMessageRepository {
    func fetchMessages(threadId: String) async throws -> [ChatMessageDTO]
    func sendMessage(threadId: String, text: String) async throws -> ChatMessageDTO
    
//    func fetchMessages(threadId: String) async throws -> [ChatMessage]
//    func sendMessage(threadId: String, text: String) async throws -> ChatMessage
//    func fetchResendMessage(threadId: String) throws -> [ChatMessage]
    /// 시나리오 테스트용
    func sendFailedMessage(threadId: String, text: String) async throws
//    func sendResendmessage(threadId: String, text: String, id: String) async throws -> ChatMessage
}

public final class RemoteChatMessageRepositoryImpl: RemoteChatMessageRepository {
    private let apiClient: APIClient
    
    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    public func fetchMessages(threadId: String) async throws -> [ChatMessageDTO] {
        let dto = try await apiClient.request(
            Endpoint(path: "/chats/messages/\(threadId)"),
            as: [ChatMessageDTO].self
        )
        return dto
    }
    
    public func sendMessage(threadId: String, text: String) async throws -> ChatMessageDTO {
        let dto = try await apiClient.request(
            Endpoint(path: "/chats/send/\(threadId)?text=\(text)"),
            as: ChatMessageDTO.self
        )
        
        return dto
    }
    
    public func sendResendmessage(threadId: String, text: String, id: String) async throws -> ChatMessageDTO {
        let dto = try await apiClient.request(
            Endpoint(path: "/chats/send/\(threadId)?text=\(text)"),
            as: ChatMessageDTO.self
        )
        
        return dto
    }
    
    public func sendFailedMessage(threadId: String, text: String) async throws {
        let _ = try await apiClient.request(
            Endpoint(path: "/chats/resend"),
            as: ChatMessageDTO.self
        )
    }
}
