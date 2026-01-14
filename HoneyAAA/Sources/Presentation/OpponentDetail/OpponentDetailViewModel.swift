import Foundation

/// 상대방 상세 정보 화면에 대한 ViewModel입니다.
/// - OpponentListViewModel과는 독립적으로 OpponentRepository를 직접 호출합니다.
/// - 같은 DTO를 받지만, OpponentDetail 도메인 모델로 변환하여 사용합니다.
@MainActor
final class OpponentDetailViewModel: ObservableObject {
    @Published var detail: OpponentDetailUIModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let opponentRepository: OpponentRepository

    init(
        opponentId: String,
        opponentRepository: OpponentRepository? = nil
    ) {
        if let repository = opponentRepository {
            self.opponentRepository = repository
        } else {
            // 기본 의존성 구성: Presentation 레이어에서 Data를 직접 조립
            let apiClient = MockAPIClient()
            self.opponentRepository = RemoteOpponentRepository(apiClient: apiClient)
        }

        Task {
            await load(opponentId: opponentId)
        }
    }

    /// 상대방 상세 정보를 불러옵니다.
    func load(opponentId: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let opponentDetail = try await opponentRepository.fetchOpponentDetail(by: opponentId)
            detail = opponentDetail.toDetailUIModel()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
