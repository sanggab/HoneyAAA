import Foundation

/// 내정보 화면 ViewModel 입니다.
@MainActor
final class MyPageViewModel: ObservableObject {
    @Published var profile: MyProfileUIModel?
    @Published var isLoading: Bool = false
    @Published var isSaving: Bool = false
    @Published var errorMessage: String?

    private let userProfileRepository: UserProfileRepository

    init(userProfileRepository: UserProfileRepository? = nil) {
        if let userProfileRepository {
            self.userProfileRepository = userProfileRepository
        } else {
            let apiClient = MockAPIClient()
            self.userProfileRepository = RemoteUserProfileRepository(apiClient: apiClient)
        }

        Task {
            await load()
        }
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let domain = try await userProfileRepository.fetchProfile()
            profile = domain.toUIModel()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func save() async {
        guard var uiModel = profile else { return }
        isSaving = true
        errorMessage = nil
        do {
            let saved = try await userProfileRepository.updateProfile(
                id: uiModel.id,
                nickname: uiModel.nickname,
                introduction: uiModel.introduction,
                interests: uiModel.interestsText
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) })
            
            uiModel = saved.toUIModel()
            profile = uiModel
        } catch {
            errorMessage = error.localizedDescription
        }
        isSaving = false
    }
}

