import SwiftUI

/// 상대방 상세 정보를 보여주는 화면입니다.
/// - 요구사항 1-2: 상세 정보 표시
/// - 요구사항 1-3: "메세지 보내기" 버튼으로 채팅방 이동
/// - OpponentDetailViewModel을 사용하여 RemoteOpponentDetailRepository에서 데이터를 가져옵니다.
struct OpponentDetailView: View {
    @StateObject var viewModel: OpponentDetailViewModel
    @State private var isChatPresented: Bool = false

    init(opponentId: String, viewModel: OpponentDetailViewModel? = nil) {
        if let vm = viewModel {
            _viewModel = StateObject(wrappedValue: vm)
        } else {
            _viewModel = StateObject(wrappedValue: OpponentDetailViewModel(opponentId: opponentId))
        }
    }

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text(errorMessage)
                        .foregroundColor(.red)
                    Button("다시 시도") {
                        if let detail = viewModel.detail {
                            Task {
                                await viewModel.load(opponentId: detail.id)
                            }
                        }
                    }
                }
            } else if let detail = viewModel.detail {
                contentView(detail: detail)
            } else {
                Text("데이터를 불러올 수 없습니다.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle(viewModel.detail?.displayName ?? "상대 정보")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isChatPresented) {
            if let detail = viewModel.detail {
                let threadId = "opponent-\(detail.id)"
                ChatRoomView(
                    threadId: threadId,
                    opponentName: detail.displayName,
                    viewModel: ChatRoomViewModel(
                        threadId: threadId,
                        opponentName: detail.displayName
                    )
                )
            }
        }
    }

    @ViewBuilder
    private func contentView(detail: OpponentDetailUIModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection(detail: detail)
            introductionSection(detail: detail)
            interestsSection(detail: detail)

            Spacer()

            Button(action: {
                isChatPresented = true
            }) {
                Text("메세지 보내기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
    }

    private func headerSection(detail: OpponentDetailUIModel) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 64, height: 64)
                .overlay(
                    Text(String(detail.displayName.prefix(1)))
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(detail.displayName)
                    .font(.title2.bold())
                Text(detail.ageText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }

    private func introductionSection(detail: OpponentDetailUIModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("소개")
                .font(.headline)
            Text(detail.introduction)
                .font(.body)
                .foregroundColor(.primary)
        }
    }

    private func interestsSection(detail: OpponentDetailUIModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("관심사")
                .font(.headline)
            if detail.interests.isEmpty {
                Text("등록된 관심사가 없습니다.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                WrapHStack(items: detail.interests) { interest in
                    Text(interest)
                        .font(.footnote)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                }
            }
        }
    }
}

/// 간단한 태그 레이아웃을 위한 래핑 HStack 입니다.
private struct WrapHStack<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let items: Data
    let content: (Data.Element) -> Content

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            ForEach(Array(items), id: \.self) { item in
                content(item)
                    .padding(4)
                    .alignmentGuide(.leading) { dimension in
                        if width + dimension.width > geometry.size.width {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        width -= dimension.width
                        return result
                    }
                    .alignmentGuide(.top) { dimension in
                        let result = height
                        if item == items.last {
                            DispatchQueue.main.async {
                                totalHeight = abs(height) + dimension.height
                            }
                        }
                        return result
                    }
            }
        }
    }
}

