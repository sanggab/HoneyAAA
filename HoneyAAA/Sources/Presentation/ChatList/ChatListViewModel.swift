import Foundation

/// 채팅 리스트 화면 ViewModel 입니다.
@MainActor
final class ChatListViewModel: ObservableObject {
    @Published var threads: [ChatThreadUIModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: ChatThreadRepository

    init(repository: ChatThreadRepository? = nil) {
        if let repository {
            self.repository = repository
        } else {
            let apiClient = MockAPIClient()
            self.repository = RemoteChatThreadRepository(apiClient: apiClient)
        }

        Task {
            await load()
        }
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let list = try await repository.fetchThreads()
            threads = list.map { $0.toUIModel() }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

