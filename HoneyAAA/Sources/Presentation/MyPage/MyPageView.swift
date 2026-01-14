import SwiftUI

/// 내정보 화면입니다.
/// - 요구사항 4-1, 4-2, 4-3, 4-4 대응
struct MyPageView: View {
    @StateObject var viewModel: MyPageViewModel

    init(viewModel: MyPageViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
            } else if let profile = viewModel.profile {
                Section(header: Text("기본 정보")) {
                    TextField("닉네임", text: binding(\.nickname, on: profile))
                    TextField("소개", text: binding(\.introduction, on: profile))
                    TextField("관심사 (쉼표 구분)", text: binding(\.interestsText, on: profile))
                }

                Section {
                    Button {
                        Task { await viewModel.save() }
                    } label: {
                        if viewModel.isSaving {
                            ProgressView()
                        } else {
                            Text("저장")
                        }
                    }
                }
            } else {
                Text("프로필 정보를 불러오지 못했습니다.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("내정보")
        .alert("에러", isPresented: .constant(viewModel.errorMessage != nil), actions: {
            Button("닫기") { viewModel.errorMessage = nil }
        }, message: {
            Text(viewModel.errorMessage ?? "")
        })
    }

    /// Published 프로퍼티에 있는 profile을 수정하기 위한 헬퍼
    private func binding<Value>(
        _ keyPath: WritableKeyPath<MyProfileUIModel, Value>,
        on model: MyProfileUIModel
    ) -> Binding<Value> {
        Binding(
            get: { viewModel.profile?[keyPath: keyPath] ?? model[keyPath: keyPath] },
            set: { newValue in
                viewModel.profile?[keyPath: keyPath] = newValue
            }
        )
    }
}

