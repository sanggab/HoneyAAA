import Foundation

/// 내정보 화면에 필요한 UI 모델입니다.
struct MyProfileUIModel: Identifiable, Equatable {
    let id: String
    var nickname: String
    var introduction: String
    var interestsText: String
}

extension UserProfile {
    func toUIModel() -> MyProfileUIModel {
        MyProfileUIModel(
            id: id,
            nickname: nickname,
            introduction: introduction ?? "",
            interestsText: interests.joined(separator: ", ")
        )
    }

    func updating(from uiModel: MyProfileUIModel) -> UserProfile {
        UserProfile(
            id: id,
            nickname: uiModel.nickname,
            introduction: uiModel.introduction,
            interests: uiModel.interestsText
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
        )
    }
}

