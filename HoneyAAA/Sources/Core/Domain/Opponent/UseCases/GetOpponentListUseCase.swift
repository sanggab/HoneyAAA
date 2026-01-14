import Foundation

/// 상대방 리스트를 가져오는 유스케이스입니다.
/// - Presentation -> Domain -> Data 흐름을 보여주기 위한 예시입니다.
public struct GetOpponentListUseCase {
    private let opponentRepository: OpponentRepository

    public init(opponentRepository: OpponentRepository) {
        self.opponentRepository = opponentRepository
    }

    /// 상대방 ID 리스트를 가져온 뒤, 각 ID에 대한 요약 정보를 합성하여 반환합니다.
    public func execute() async throws -> [OpponentSummary] {
        let ids = try await opponentRepository.fetchOpponentIds()
        var summaries: [OpponentSummary] = []
        for id in ids {
            let summary = try await opponentRepository.fetchOpponentSummary(by: id)
            summaries.append(summary)
        }
        return summaries
    }
}

