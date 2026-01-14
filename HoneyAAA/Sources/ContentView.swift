import SwiftUI

/// 기존 템플릿에서 생성된 진입 뷰입니다.
/// 실제 앱에서는 `RootTabView`를 래핑하여 미리보기 및 진입을 단순화합니다.
public struct ContentView: View {
    public init() {}

    public var body: some View {
        RootTabView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
