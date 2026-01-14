import Foundation

/// 실제(또는 Mock) API를 통해 상대방 데이터를 가져오는 레포지토리 구현체입니다.
/// - UserProfileRepository와 동일한 패턴으로, 하나의 구현체에 모든 메서드를 포함합니다.
public final class RemoteOpponentRepository: OpponentRepository {
    private let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func fetchOpponentIds() async throws -> [String] {
        try await apiClient.request(Endpoint(path: "/opponents/ids"), as: [String].self)
    }

    public func fetchOpponentSummary(by id: String) async throws -> OpponentSummary {
        let dto = try await apiClient.request(
            Endpoint(path: "/opponents/detail/\(id)"),
            as: OpponentDetailDTO.self
        )
        return dto.toSummaryDomain()
    }

    public func fetchOpponentDetail(by id: String) async throws -> OpponentDetail {
        let dto = try await apiClient.request(
            Endpoint(path: "/opponents/detail/\(id)"),
            as: OpponentDetailDTO.self
        )
        return dto.toDetailDomain()
    }
}

