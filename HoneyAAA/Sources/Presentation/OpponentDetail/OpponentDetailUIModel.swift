import Foundation

/// 상대 상세 정보 화면에 필요한 UI 모델입니다.
struct OpponentDetailUIModel: Identifiable, Equatable {
    let id: String
    let displayName: String
    let ageText: String
    let introduction: String
    let interests: [String]
}

extension OpponentDetail {
    /// 도메인 모델을 상세 UI 모델로 변환합니다.
    func toDetailUIModel() -> OpponentDetailUIModel {
        OpponentDetailUIModel(
            id: id,
            displayName: name,
            ageText: age.map { "\($0)살" } ?? "나이 정보 없음",
            introduction: introduction ?? "소개글이 없습니다.",
            interests: interests
        )
    }
}
