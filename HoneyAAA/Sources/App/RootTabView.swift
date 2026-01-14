import SwiftUI

/// 앱의 메인 탭 구조를 담당하는 루트 뷰입니다.
/// - 탭 구성: 상대 리스트, 채팅 리스트, 내 정보
struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                OpponentListView(viewModel: OpponentListViewModel())
            }
            .tabItem {
                Image(systemName: "person.2.fill")
                Text("상대 리스트")
            }

            NavigationStack {
                ChatListView(viewModel: ChatListViewModel())
            }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                Text("채팅리스트")
            }

            NavigationStack {
                MyPageView(viewModel: MyPageViewModel())
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("내정보")
            }
        }
    }
}

