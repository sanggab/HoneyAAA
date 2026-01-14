import SwiftUI

/// 채팅 리스트 화면입니다.
/// - 요구사항 2-1, 2-2, 2-3 대응
struct ChatListView: View {
    @StateObject var viewModel: ChatListViewModel
    @State private var selectedThread: ChatThreadUIModel?

    init(viewModel: ChatListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
            }
            ForEach(viewModel.threads) { thread in
                Button {
                    selectedThread = thread
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(thread.opponentName)
                            .font(.headline)
                        Text(thread.lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        Text(thread.lastMessageTime)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("채팅리스트")
        .alert("에러", isPresented: .constant(viewModel.errorMessage != nil), actions: {
            Button("닫기") { viewModel.errorMessage = nil }
        }, message: {
            Text(viewModel.errorMessage ?? "")
        })
        .navigationDestination(item: $selectedThread) { thread in
            ChatRoomView(
                threadId: thread.id,
                opponentName: thread.opponentName,
                viewModel: ChatRoomViewModel(threadId: thread.id, opponentName: thread.opponentName)
            )
        }
    }
}

