
import SwiftUI
import SwiftData

struct TagListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tag.name) private var tags: [Tag]
    @State private var isAddingIdea = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(tags) { tag in
                    NavigationLink(destination: FilteredIdeaListView(tag: tag).navigationTitle(tag.name)) {
                        Text(tag.name)
                    }
                }
            }
            .navigationTitle("標籤")
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
        if tags.isEmpty {
            let sampleTag1 = Tag(name: "正能量")
            let sampleTag2 = Tag(name: "生活小聰明")
            modelContext.insert(sampleTag1)
            modelContext.insert(sampleTag2)
        }
    }
}

#Preview {
    TagListView()
        .modelContainer(for: Tag.self, inMemory: true)
}
