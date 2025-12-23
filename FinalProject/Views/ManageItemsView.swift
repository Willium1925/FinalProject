
import SwiftUI
import SwiftData

// 意思是：這個 View 接受一個類型 T，但 T 必須遵守 Nameable 協定
struct ManageItemsView<T: Nameable>: View {
    @Environment(\.modelContext) private var modelContext
    
    // 這裡的 @Query 會自動根據 T 的具體類型去資料庫抓資料
    @Query private var items: [T]

    @State private var isShowingAddAlert = false
    @State private var newItemName = ""

    // 用來控制編輯狀態
    @State private var editingItem: T?
    @State private var editingName = ""
    @State private var isShowingEditAlert = false

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
                    .contextMenu {
                        Button {
                            startEditing(item)
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
        .navigationTitle("管理\(title)")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { isShowingAddAlert = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        // 新增 Alert
        .alert("新增\(title)", isPresented: $isShowingAddAlert) {
            TextField("名稱", text: $newItemName)
            Button("新增") {
                addItem()
            }
            Button("取消", role: .cancel) {}
        }
        // 編輯 Alert
        .alert("編輯\(title)", isPresented: $isShowingEditAlert) {
            TextField("名稱", text: $editingName)
            Button("儲存") {
                saveEdit()
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

    private func startEditing(_ item: T) {
        editingItem = item
        editingName = item.name
        isShowingEditAlert = true
    }

    private func saveEdit() {
        guard let item = editingItem, !editingName.isEmpty else { return }
        item.name = editingName
        editingItem = nil
        editingName = ""
    }

    private func deleteItem(_ item: T) {
        modelContext.delete(item)
    }
}

#Preview {
    ManageItemsView<Scene>()
        .modelContainer(for: Scene.self, inMemory: true)
}
