
import SwiftUI
import SwiftData

struct SceneListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Scene.name) private var scenes: [Scene]
    @State private var isAddingIdea = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(scenes) { scene in
                    NavigationLink(destination: FilteredIdeaListView(scene: scene).navigationTitle(scene.name)) {
                        Text(scene.name)
                    }
                }
            }
            .navigationTitle("場景")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isAddingIdea = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingIdea) {
                AddIdeaView()
            }
            .onAppear(perform: addSampleData)
        }
    }

    // 方便測試，之後可以移除
    private func addSampleData() {
        if scenes.isEmpty {
            let sampleScene1 = Scene(name: "工作心法")
            let sampleScene2 = Scene(name: "社交話題")
            modelContext.insert(sampleScene1)
            modelContext.insert(sampleScene2)
        }
    }
}

#Preview {
    SceneListView()
        .modelContainer(for: Scene.self, inMemory: true)
}
