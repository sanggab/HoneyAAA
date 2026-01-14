import Foundation

/// 상대방 상세 정보에 대한 DTO입니다.
/// - API Response 전용 모델로, 도메인 모델로 변환하여 사용합니다.
/// - OpponentListViewModel과 OpponentDetailViewModel 모두에서 사용합니다.
public struct OpponentDetailDTO: Codable {
    public let id: String
    public let name: String
    public let age: Int?
    public let introduction: String?
    public let interests: [String]?
    public let profileImageURL: String?
}

extension OpponentDetailDTO {
    /// DTO를 OpponentSummary 도메인 모델로 변환합니다.
    /// - OpponentListViewModel에서 사용합니다.
    public func toSummaryDomain() -> OpponentSummary {
        OpponentSummary(
            id: id,
            name: name,
            age: age,
            interests: interests ?? []
        )
    }

    /// DTO를 OpponentDetail 도메인 모델로 변환합니다.
    /// - OpponentDetailViewModel에서 사용합니다.
    public func toDetailDomain() -> OpponentDetail {
        OpponentDetail(
            id: id,
            name: name,
            age: age,
            introduction: introduction,
            interests: interests ?? [],
            profileImageURL: profileImageURL.flatMap(URL.init(string:))
        )
    }
}

