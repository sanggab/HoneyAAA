import Foundation

/// 상대방 관련 데이터를 제공하는 레포지토리입니다.
/// - Data 레이어에서 구현합니다.
/// - UserProfileRepository와 동일한 패턴으로, 도메인 엔티티별로 하나의 Repository를 사용합니다.
public protocol OpponentRepository {
    /// 상대방 ID 리스트를 가져옵니다.
    func fetchOpponentIds() async throws -> [String]
    
    /// 상대방 요약 정보를 가져옵니다.
    /// - OpponentListViewModel에서 사용합니다.
    func fetchOpponentSummary(by id: String) async throws -> OpponentSummary
    
    /// 상대방 상세 정보를 가져옵니다.
    /// - OpponentDetailViewModel에서 사용합니다.
    func fetchOpponentDetail(by id: String) async throws -> OpponentDetail
}

