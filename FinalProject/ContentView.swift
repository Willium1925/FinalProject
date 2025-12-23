
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SceneListView()
                .tabItem {
                    Label("場景", systemImage: "film.stack")
                }

            TagListView()
                .tabItem {
                    Label("標籤", systemImage: "tag")
                }

            HomeView()
                .tabItem {
                    // 將圖示改為燈泡
                    Label("來源", systemImage: "lightbulb")
                }

            SearchView()
                .tabItem {
                    Label("搜尋", systemImage: "magnifyingglass")
                }

            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Idea.self, inMemory: true)
}
