
import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Scene.name) private var scenes: [Scene]
    @Query(sort: \Tag.name) private var tags: [Tag]
    @Query(sort: \Source.name) private var sources: [Source]

    var body: some View {
        NavigationStack {
            Form {
                Section("場景") {
                    ForEach(scenes) { scene in
                        Text(scene.name)
                    }
                    .onDelete(perform: deleteScenes)
                }

                Section("標籤") {
                    ForEach(tags) { tag in
                        Text(tag.name)
                    }
                    .onDelete(perform: deleteTags)
                }

                Section("來源") {
                    ForEach(sources) { source in
                        Text(source.name)
                    }
                    .onDelete(perform: deleteSources)
                }
            }
            .navigationTitle("設定")
        }
    }

    private func deleteScenes(at offsets: IndexSet) {
        for offset in offsets {
            let scene = scenes[offset]
            modelContext.delete(scene)
        }
    }

    private func deleteTags(at offsets: IndexSet) {
        for offset in offsets {
            let tag = tags[offset]
            modelContext.delete(tag)
        }
    }

    private func deleteSources(at offsets: IndexSet) {
        for offset in offsets {
            let source = sources[offset]
            modelContext.delete(source)
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Scene.self, inMemory: true)
}
