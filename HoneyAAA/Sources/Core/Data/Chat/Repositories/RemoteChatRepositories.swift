import Foundation

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

public final class RemoteChatMessageRepository: ChatMessageRepository {
    private let apiClient: APIClient
    
    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    public func fetchMessages(threadId: String) async throws -> [ChatMessage] {
        let dto = try await apiClient.request(
            Endpoint(path: "/chats/messages/\(threadId)"),
            as: [ChatMessageDTO].self
        )
        return dto.map { $0.toDomain() }
    }
    
    public func sendMessage(threadId: String, text: String) async throws -> ChatMessage {
        do {
            let dto = try await apiClient.request(
                Endpoint(path: "/chats/send/\(threadId)?text=\(text)"),
                as: ChatMessageDTO.self
            )
            
            return dto.toDomain()
        } catch {
            throw error
        }
    }
}
