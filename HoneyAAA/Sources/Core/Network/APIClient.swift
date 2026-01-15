import Foundation

/// 공통 API 클라이언트 프로토콜입니다.
/// 실제 네트워크 통신 또는 Mock 데이터 제공에 사용할 수 있습니다.
public protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}

/// 간단한 Endpoint 정의입니다. 실제 프로젝트에서는 HTTP 메서드, 헤더 등을 확장할 수 있습니다.
public struct Endpoint {
    public let path: String

    public init(path: String) {
        self.path = path
    }
}

/// 네트워크 통신 대신 하드코딩된 Mock 데이터를 반환하는 클라이언트입니다.
/// - 실제 API 연동 시 이 부분을 URLSession 기반 구현으로 교체하면 됩니다.
public final class MockAPIClient: APIClient {
    public init() {}

    public func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let data: Data
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        switch endpoint.path {
        case "/opponents/ids":
            data = try encoder.encode(["1", "2", "3"])

        case _ where endpoint.path.hasPrefix("/opponents/detail/"):
            let id = endpoint.path
                .replacingOccurrences(of: "/opponents/detail/", with: "")

            let sample: [String: OpponentDetailDTO] = [
                "1": OpponentDetailDTO(
                    id: "1",
                    name: "회원",
                    age: 29,
                    introduction: "iOS를 좋아하는 사람",
                    interests: ["Swift", "Clean Architecture"],
                    profileImageURL: nil
                ),
                "2": OpponentDetailDTO(
                    id: "2",
                    name: "하니",
                    age: 27,
                    introduction: "대화하는 걸 좋아해요",
                    interests: ["책", "카페"],
                    profileImageURL: nil
                ),
                "3": OpponentDetailDTO(
                    id: "3",
                    name: "AAA",
                    age: nil,
                    introduction: nil,
                    interests: [],
                    profileImageURL: nil
                )
            ]

            guard let dto = sample[id] else {
                throw NSError(
                    domain: "MockAPIClient",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "해당 id의 상대가 없습니다."]
                )
            }

            data = try encoder.encode(dto)


        case "/chats/threads":
            let threads = [
                ChatThreadDTO(
                    id: "thread-1",
                    opponentName: "윤",
                    lastMessage: "안녕하세요!",
                    lastMessageAt: Date()
                ),
            ]
            data = try encoder.encode(threads)

        case _ where endpoint.path.hasPrefix("/chats/messages/"):
            let messages = [
                ChatMessageDTO(
                    id: "m1",
                    text: "안녕하세요!",
                    isMine: false,
                    sentAt: Date()
                ),
                ChatMessageDTO(
                    id: "m2",
                    text: "반가워요 :)",
                    isMine: true,
                    sentAt: Date()
                ),
            ]
            data = try encoder.encode(messages)

        case _ where endpoint.path.hasPrefix("/chats/send/"):
            // 단순하게 전송 텍스트를 에코하여 반환
            let text = endpoint.path.components(separatedBy: "text=").last ?? "메시지"
            print("상갑 logEvent \(#function) text \(text)")
            let message = ChatMessageDTO(
                id: UUID().uuidString,
                text: text.removingPercentEncoding ?? text,
                isMine: true,
                sentAt: Date()
            )
            print("상갑 logEvent \(#function) message \(message)")
            data = try encoder.encode(message)
            print("상갑 logEvent \(#function) data \(data)")
        case "/chats/resend":
            throw MockError.resend
        case "/user/profile":
            let profile = UserProfileDTO(
                id: "me",
                nickname: "나",
                introduction: "소개글을 입력해보세요.",
                interests: ["iOS", "SwiftUI"]
            )
            data = try encoder.encode(profile)

        default:
            throw NSError(domain: "MockAPIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "지원되지 않는 엔드포인트"])
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}

public enum MockError: Error {
    case resend
}

extension MockError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .resend:
            return "resend error"
        }
    }
}
