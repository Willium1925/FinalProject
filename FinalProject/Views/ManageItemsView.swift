
import SwiftUI
import SwiftData

struct ManageItemsView<T: Nameable>: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [T]

    @State private var isShowingAddAlert = false
    @State private var newItemName = ""

    private let title: String

    init() {
        let typeName = String(describing: T.self)
        if typeName == "Scene" {
            self.title = "場景"
        } else if typeName == "Tag" {
            self.title = "標籤"
        } else if typeName == "Source" {
            self.title = "來源"
        } else {
            self.title = "項目"
        }

        _items = Query(sort: \T.name)
    }

    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.name)
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("管理\(title)")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { isShowingAddAlert = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("新增\(title)", isPresented: $isShowingAddAlert) {
            TextField("名稱", text: $newItemName)
            Button("新增") {
                addItem()
            }
            Button("取消", role: .cancel) {}
        }
    }

    private func addItem() {
        guard !newItemName.isEmpty else { return }
        let newItem = T(name: newItemName)
        modelContext.insert(newItem)
        newItemName = ""
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

#Preview {
    ManageItemsView<Scene>()
        .modelContainer(for: Scene.self, inMemory: true)
}
