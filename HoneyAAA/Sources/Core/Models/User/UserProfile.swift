import Foundation

/// 내 정보 도메인 모델입니다.
public struct UserProfile: Identifiable, Equatable {
    public let id: String
    public var nickname: String
    public var introduction: String?
    public var interests: [String]

    public init(
        id: String,
        nickname: String,
        introduction: String?,
        interests: [String]
    ) {
        self.id = id
        self.nickname = nickname
        self.introduction = introduction
        self.interests = interests
    }
}

