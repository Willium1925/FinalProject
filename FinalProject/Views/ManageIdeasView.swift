
import SwiftUI
import SwiftData

struct ManageIdeasView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Idea.createdAt, order: .reverse) private var items: [Idea]

    // 用來控制編輯 Sheet 的顯示
    @State private var editingIdea: Idea?

    var body: some View {
        List {
            ForEach(items) { item in
                VStack(alignment: .leading) {
                    Text(item.content)
                    if !item.note.isEmpty {
                        Text(item.note).font(.caption).foregroundColor(.secondary)
                    }
                }
                .contextMenu {
                    Button {
                        editingIdea = item
                    } label: {
                        Label("編輯", systemImage: "pencil")
                    }

                    Button(role: .destructive) {
                        deleteItem(item)
                    } label: {
                        Label("刪除", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("管理所有內容")
        .sheet(item: $editingIdea) { idea in
            AddIdeaView(ideaToEdit: idea)
        }
    }

    private func deleteItem(_ item: Idea) {
        modelContext.delete(item)
    }
}

#Preview {
    ManageIdeasView()
        .modelContainer(for: Idea.self, inMemory: true)
}
