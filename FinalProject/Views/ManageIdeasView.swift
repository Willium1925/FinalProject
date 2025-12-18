
import SwiftUI
import SwiftData

struct ManageIdeasView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Idea.createdAt, order: .reverse) private var items: [Idea]

    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink(destination: IdeaDetailView(idea: item)) {
                    VStack(alignment: .leading) {
                        Text(item.content)
                        if !item.note.isEmpty {
                            Text(item.note).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("管理所有內容")
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

#Preview {
    ManageIdeasView()
        .modelContainer(for: Idea.self, inMemory: true)
}
