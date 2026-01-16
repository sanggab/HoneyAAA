import SwiftUI

/// 채팅방 화면입니다.
/// - 요구사항 3-1, 3-2, 3-3, 3-4 대응
struct ChatRoomView: View {
    let threadId: String
    let opponentName: String
    @StateObject var viewModel: ChatRoomViewModel

    init(
        threadId: String,
        opponentName: String,
        viewModel: ChatRoomViewModel
    ) {
        self.threadId = threadId
        self.opponentName = opponentName
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                messageList
            }
            inputArea
        }
        .navigationTitle(opponentName)
        .navigationBarTitleDisplayMode(.inline)
        .alert("에러", isPresented: .constant(viewModel.errorMessage != nil), actions: {
            Button("닫기") { viewModel.errorMessage = nil }
        }, message: {
            Text(viewModel.errorMessage ?? "")
        })
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.messages) { message in
                        HStack(alignment: .bottom) {
                            if message.isMine { Spacer() }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(message.text)
                                    .padding(10)
                                    .background(message.isMine ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(message.isMine ? .white : .primary)
                                    .cornerRadius(12)
                                Text(message.timeText)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            if !message.isMine { Spacer() }
                        }
                        .id(message.id)
                    }
                }
                .padding()
            }
            .onChange(of: viewModel.messages.count) { _ in
                if let lastId = viewModel.messages.last?.id {
                    proxy.scrollTo(lastId, anchor: .bottom)
                }
            }
        }
    }

    private var inputArea: some View {
        HStack {
            TextField("메시지를 입력하세요", text: $viewModel.inputText)
                .textFieldStyle(.roundedBorder)
            
            Button("전송") {
                Task { await viewModel.send() }
            }
            .disabled(viewModel.inputText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

