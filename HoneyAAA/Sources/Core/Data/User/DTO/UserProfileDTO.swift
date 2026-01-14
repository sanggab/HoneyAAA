import Foundation

/// 내 정보 API Response DTO 입니다.
public struct UserProfileDTO: Codable {
    public let id: String
    public let nickname: String
    public let introduction: String?
    public let interests: [String]?
}

extension UserProfileDTO {
    public func toDomain() -> UserProfile {
        UserProfile(
            id: id,
            nickname: nickname,
            introduction: introduction,
            interests: interests ?? []
        )
    }
}
