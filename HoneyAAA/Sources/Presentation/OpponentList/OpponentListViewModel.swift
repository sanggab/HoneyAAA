import Foundation

/// 상대 리스트 화면에 대한 ViewModel 입니다.
/// - Presentation -> Domain -> Data 흐름을 사용합니다.
@MainActor
final class OpponentListViewModel: ObservableObject {
    @Published var cards: [OpponentCardUIModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let getOpponentListUseCase: GetOpponentListUseCase

    init(
        getOpponentListUseCase: GetOpponentListUseCase? = nil
    ) {
        if let useCase = getOpponentListUseCase {
            self.getOpponentListUseCase = useCase
        } else {
            // 기본 의존성 구성: Presentation 레이어에서 Domain, Data를 직접 조립
            let apiClient = MockAPIClient()
            let opponentRepository = RemoteOpponentRepository(apiClient: apiClient)
            self.getOpponentListUseCase = GetOpponentListUseCase(
                opponentRepository: opponentRepository
            )
        }

        Task {
            await load()
        }
    }

    /// 상대 리스트를 불러옵니다.
    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let summaries = try await getOpponentListUseCase.execute()
            cards = summaries.map { $0.toCardUIModel() }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// 다음 회원으로 넘깁니다.
    func moveToNextCard() {
        guard !cards.isEmpty else { return }
        cards.removeFirst()
    }
}

