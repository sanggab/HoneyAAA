import Foundation

/// 채팅방 화면 ViewModel 입니다.
@MainActor
final class ChatRoomViewModel: ObservableObject {
    @Published var messages: [ChatMessageUIModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var inputText: String = ""

    private let threadId: String
    private let repository: ChatMessageRepository

    init(
        threadId: String,
        opponentName: String,
        repository: ChatMessageRepository? = nil
    ) {
        self.threadId = threadId

        if let repository {
            self.repository = repository
        } else {
            let apiClient = MockAPIClient()
            self.repository = RemoteChatMessageRepository(apiClient: apiClient)
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
            messages = fetched.map { $0.toUIModel() }
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
            print("상갑 logEvent \(#function) errorMessage \(errorMessage)")
        }
    }
}

