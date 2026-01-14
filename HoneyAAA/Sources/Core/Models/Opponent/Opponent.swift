import Foundation

/// 상대방 리스트용 요약 정보를 나타내는 도메인 모델입니다.
/// - OpponentListViewModel에서 사용됩니다.
public struct OpponentSummary: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let age: Int?
    public let interests: [String]

    public init(
        id: String,
        name: String,
        age: Int?,
        interests: [String]
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.interests = interests
    }
}

/// 상대방 상세 정보를 나타내는 도메인 모델입니다.
/// - OpponentDetailViewModel에서 사용됩니다.
public struct OpponentDetail: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let age: Int?
    public let introduction: String?
    public let interests: [String]
    public let profileImageURL: URL?

    public init(
        id: String,
        name: String,
        age: Int?,
        introduction: String?,
        interests: [String],
        profileImageURL: URL?
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.introduction = introduction
        self.interests = interests
        self.profileImageURL = profileImageURL
    }
}

