import Foundation


public protocol ChatRepository {
    func fetchMessages(threadId: String) async throws -> [ChatMessage]
    func sendMessage(threadId: String, text: String) async throws -> ChatMessage
    
    func fetchResendMessages(_ threadId: String) -> [ChatMessage]
    func sendResendmessage(threadId: String, text: String, id: String) async throws -> ChatMessage
    /// 시나리오 테스트용
    func sendFailedMessage(threadId: String, text: String) async throws
}

public struct DefaultChatRepository: ChatRepository {
    private let remote: RemoteChatMessageRepository
    private let local: LocalChatMessageRepository
    
    public init(
        local: LocalChatMessageRepository,
        remote: RemoteChatMessageRepository
    ) {
        self.local = local
        self.remote = remote
    }
    
    public func fetchMessages(threadId: String) async throws -> [ChatMessage] {
        let dto: [ChatMessageDTO] = try await remote.fetchMessages(threadId: threadId)
        return dto.map { $0.toDomain() }
    }
    
    public func sendMessage(threadId: String, text: String) async throws -> ChatMessage {
        do {
            let dto: ChatMessageDTO = try await remote.sendMessage(threadId: threadId, text: text)
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
    
    public func fetchResendMessages(_ threadId: String) -> [ChatMessage] {
        return self.local.fetchResendMessages(threadId)
    }
    
    public func sendResendmessage(threadId: String, text: String, id: String) async throws -> ChatMessage {
        do {
            let dto: ChatMessageDTO = try await remote.sendMessage(threadId: threadId, text: text)
            
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
            let _ = try await remote.sendFailedMessage(threadId: threadId, text: text)
            
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
}

extension DefaultChatRepository {
    private func saveResendMessage(threadId: String, text: String) throws {
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
