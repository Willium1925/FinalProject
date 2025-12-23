
import SwiftUI
import SwiftData

struct SceneListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Scene.name) private var scenes: [Scene]
    @State private var isAddingIdea = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(scenes) { scene in
                            NavigationLink(destination: FilteredIdeaListView(scene: scene).navigationTitle(scene.name)) {
                                SceneRowView(scene: scene)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("場景")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { isAddingIdea = true }) {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $isAddingIdea) {
                AddIdeaView()
            }
            .onAppear(perform: addSampleData)
        }
    }

    private func addSampleData() {
        if scenes.isEmpty {
            modelContext.insert(Scene(name: "工作心法"))
            modelContext.insert(Scene(name: "社交話題"))
            modelContext.insert(Scene(name: "電影台詞"))
            modelContext.insert(Scene(name: "人生哲學"))
        }
    }
}

struct SceneRowView: View {
    let scene: Scene

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(scene.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("\(scene.ideas.count) 個內容")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
                .font(.caption)
        }
        .padding(20) // 增加內距，讓卡片看起來更飽滿
        .background(Color.gradient(seed: scene.name)) // 整張卡片使用漸層背景
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    SceneListView()
        .modelContainer(for: Scene.self, inMemory: true)
}
