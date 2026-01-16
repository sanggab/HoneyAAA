import Foundation

/// 채팅 스레드 리스트를 제공하는 레포지토리입니다.
public protocol ChatThreadRepository {
    func fetchThreads() async throws -> [ChatThread]
}

/// 채팅방 메시지 목록을 제공하는 레포지토리입니다.
public protocol RemoteChatMessageRepository {
    func fetchMessages(threadId: String) async throws -> [ChatMessage]
    func sendMessage(threadId: String, text: String) async throws -> ChatMessage
    func fetchResendMessage(threadId: String) throws -> [ChatMessage]
    /// 시나리오 테스트용
    func sendFailedMessage(threadId: String, text: String) async throws
    func sendResendmessage(threadId: String, text: String, id: String) async throws -> ChatMessage
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

public final class RemoteChatMessageRepositoryImpl: RemoteChatMessageRepository {
    private let apiClient: APIClient
    
    private let local: LocalChatMessageRepository = LocalChatRepositories()
    
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
            switch error {
            case let mockError as MockError:
                switch mockError {
                case .resend:
                    try self.saveResendMessage(threadId: threadId, text: text)
                }
            default: break
            }
            
            throw error
        }
    }
    
    public func sendResendmessage(threadId: String, text: String, id: String) async throws -> ChatMessage {
        do {
            let dto = try await apiClient.request(
                Endpoint(path: "/chats/send/\(threadId)?text=\(text)"),
                as: ChatMessageDTO.self
            )
            
            try self.local.deleteResendMessage(threadId, id: id)
            
            return dto.toDomain()
        } catch {
            switch error {
            case let mockError as MockError:
                switch mockError {
                case .resend:
                    try self.saveResendMessage(threadId: threadId, text: text)
                }
            default: break
            }
            
            throw error
        }
    }
    
    public func sendFailedMessage(threadId: String, text: String) async throws {
        do {
            let _ = try await apiClient.request(
                Endpoint(path: "/chats/resend"),
                as: ChatMessageDTO.self
            )
            
        } catch {
            switch error {
            case let mockError as MockError:
                switch mockError {
                case .resend:
                    try self.saveResendMessage(threadId: threadId, text: text)
                }
            default: break
            }
            
            throw error
        }
    }
    
    public func fetchResendMessage(threadId: String) throws -> [ChatMessage] {
        return local.fetchResendMessages(threadId)
    }
    
    public func sendFailedMessage(_ threadId: String, text: String, id: String) {
        let message = ChatMessage(
            id: id,
            text: text,
            isMine: true,
            sentAt: Date(),
            isFailed: true
        )
        try? local.saveResendMessage(threadId, message: message)
    }
}


extension RemoteChatMessageRepositoryImpl {
    func saveResendMessage(threadId: String, text: String) throws {
        let resendMsg: ChatMessage = .init(
            id: UUID().uuidString,
            text: text,
            isMine: true,
            sentAt: Date(),
            isFailed: true
        )
        
        try self.local.saveResendMessage(threadId, message: resendMsg)
    }
}
