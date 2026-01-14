import Foundation

/// 내 정보 조회/수정 원격 레포지토리 구현체입니다.
public final class RemoteUserProfileRepository: UserProfileRepository {
    private let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func fetchProfile() async throws -> UserProfile {
        let dto = try await apiClient.request(Endpoint(path: "/user/profile"), as: UserProfileDTO.self)
        return dto.toDomain()
    }

    public func updateProfile(
        id: String,
        nickname: String,
        introduction: String?,
        interests: [String]
    ) async throws -> UserProfile {
        // Mock에서는 그대로 반환
        let dto = UserProfileDTO(
            id: id,
            nickname: nickname + " 수정 완료",
            introduction: introduction,
            interests: interests
        )
        // 실제 구현 시 PUT/PATCH 요청 필요
        return dto.toDomain()
    }
}

