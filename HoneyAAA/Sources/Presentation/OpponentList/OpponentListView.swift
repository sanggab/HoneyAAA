import SwiftUI

/// 상대방 카드 리스트를 보여주는 화면입니다.
/// - 요구사항 1-1: 카드를 보여주고 하단 버튼으로 다음 회원으로 넘길 수 있는 뷰
/// - 요구사항 1-2: 터치 시 상세 정보
/// - 요구사항 1-3: 상세에서 "메세지 보내기" 버튼으로 채팅방 이동
struct OpponentListView: View {
    @StateObject var viewModel: OpponentListViewModel

    init(viewModel: OpponentListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text(errorMessage)
                        .foregroundColor(.red)
                    Button("다시 시도") {
                        Task {
                            await viewModel.load()
                        }
                    }
                }
            } else if viewModel.cards.isEmpty {
                Text("더 이상 상대가 없습니다.")
                    .foregroundColor(.secondary)
            } else {
                cardStack
                nextButton
            }
        }
        .navigationTitle("상대 리스트")
    }

    private var cardStack: some View {
        ZStack {
            ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
                OpponentCardView(card: card)
                    .zIndex(Double(viewModel.cards.count - index))
                    .scaleEffect(index == 0 ? 1.0 : 0.95)
                    .offset(y: Double(min(index, 2)) * 8)
                    .transition(
                        .asymmetric(
                            insertion: .identity,
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        )
                    )
            }
        }
        .padding()
    }


    private var nextButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                viewModel.moveToNextCard()
            }
        }) {
            Text("다음 회원")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

/// 단일 상대 카드를 표현하는 뷰입니다.
private struct OpponentCardView: View {
    let card: OpponentCardUIModel

    var body: some View {
        NavigationLink(destination: OpponentDetailView(opponentId: card.id)) {
            VStack(alignment: .leading, spacing: 12) {
                Text(card.displayName)
                    .font(.title2.bold())
                Text(card.ageText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(card.interestsText)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

