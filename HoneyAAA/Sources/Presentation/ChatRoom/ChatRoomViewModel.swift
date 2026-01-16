import Foundation

/// 채팅방 화면 ViewModel 입니다.
@MainActor
final class ChatRoomViewModel: ObservableObject {
    @Published var messages: [ChatMessageUIModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var inputText: String = ""

    private let threadId: String
    private let repository: ChatRepository
    
    init(
        threadId: String,
        opponentName: String,
        repository: ChatRepository? = nil
    ) {
        self.threadId = threadId

        if let repository {
            self.repository = repository
        } else {
            let local = LocalChatRepositoryImpl()
            let apiClient = MockAPIClient()
            let remote = RemoteChatMessageRepositoryImpl(apiClient: apiClient)
            self.repository = DefaultChatRepository(local: local, remote: remote)
        }

        Task {
            await load()
        }
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await repository.fetchMessages(threadId: threadId)
            var allMessages = fetched.map { $0.toUIModel() }
            
            let resends: [ChatMessage] = repository.fetchResendMessages(threadId)
            let cv: [ChatMessageUIModel] = resends.map { $0.toUIModel() }
            allMessages.append(contentsOf: cv)
            
            messages = allMessages.sorted(by: { $0.timeText < $1.timeText }) // Simple sort, better by date if available
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func send() async {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let text = inputText
        inputText = ""
        do {
            let sent = try await repository.sendMessage(threadId: threadId, text: text)
            messages.append(sent.toUIModel())
        } catch {
            errorMessage = error.localizedDescription
            if let resendMsg: ChatMessage = repository.fetchResendMessages(threadId).last {
                messages.append(resendMsg.toUIModel())
            }
        }
    }
    
    func resend(message: ChatMessageUIModel) async {
        do {
            let sent = try await repository.sendResendmessage(threadId: threadId, text: message.text, id: message.id)
            
            messages.removeAll(where: { $0.id == message.id })
            messages.append(sent.toUIModel())
        } catch {
            errorMessage = error.localizedDescription
            // If failed again, it remains in local storage, so we don't need to append again unless we removed it.
            // But usually resend logic in Repo deletes only on success.
        }
    }
    
    func mockMessage() async {
        do {
            try await repository.sendFailedMessage(threadId: threadId, text: "재전송 케이스 추가")
        } catch {
            errorMessage = error.localizedDescription
            if let resendMsg: ChatMessage = repository.fetchResendMessages(threadId).last {
                messages.append(resendMsg.toUIModel())
            }
        }
    }
}

