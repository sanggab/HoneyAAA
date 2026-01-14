import Foundation

/// 내 정보 조회 및 수정 레포지토리입니다.
public protocol UserProfileRepository {
    func fetchProfile() async throws -> UserProfile
    func updateProfile(
        id: String,
        nickname: String,
        introduction: String?,
        interests: [String]
    ) async throws -> UserProfile
}

