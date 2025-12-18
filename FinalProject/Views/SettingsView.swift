
import SwiftUI
import SwiftData

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                NavigationLink(destination: ManageIdeasView()) {
                    Label("所有內容", systemImage: "doc.text.magnifyingglass")
                }
                NavigationLink(destination: ManageItemsView<Scene>()) {
                    Label("場景", systemImage: "film.stack")
                }
                NavigationLink(destination: ManageItemsView<Tag>()) {
                    Label("標籤", systemImage: "tag")
                }
                NavigationLink(destination: ManageItemsView<Source>()) {
                    Label("來源", systemImage: "bookmark")
                }
            }
            .navigationTitle("設定")
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Scene.self, inMemory: true)
}
