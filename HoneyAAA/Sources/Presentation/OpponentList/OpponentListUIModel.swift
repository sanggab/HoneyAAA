import Foundation

/// 상대 리스트 카드에 필요한 UI 전용 모델입니다.
/// - Domain 모델에서 파생된, UI 친화적인 상태를 가집니다.
struct OpponentCardUIModel: Identifiable, Equatable {
    let id: String
    let displayName: String
    let ageText: String
    let interestsText: String
    let isVisible: Bool
}

extension OpponentSummary {
    /// 도메인 모델을 카드 UI 모델로 변환합니다.
    func toCardUIModel(isVisible: Bool = true) -> OpponentCardUIModel {
        let ageText: String = age.map { "\($0)살" } ?? "나이 정보 없음"
        let interestsText: String = interests.isEmpty ? "관심사가 아직 없어요" : interests.joined(separator: ", ")

        return OpponentCardUIModel(
            id: id,
            displayName: name,
            ageText: ageText,
            interestsText: interestsText,
            isVisible: isVisible
        )
    }
}

