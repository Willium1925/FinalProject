
import SwiftUI
import SwiftData

struct SelectionView<T: Nameable>: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    // 傳入已選擇的項目集合 (Binding)
    @Binding var selectedItems: Set<T>

    // 查詢所有項目
    @Query(sort: \T.name) private var allItems: [T]

    @State private var searchText = ""
    @State private var isShowingAddAlert = false
    @State private var newItemName = ""

    var title: String

    var filteredItems: [T] {
        if searchText.isEmpty {
            return allItems
        } else {
            return allItems.filter { $0.name.localizedStandardContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        if selectedItems.contains(item) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSelection(item)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "搜尋\(title)")
            .navigationTitle("選擇\(title)")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { isShowingAddAlert = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("新增\(title)", isPresented: $isShowingAddAlert) {
                TextField("名稱", text: $newItemName)
                Button("新增") {
                    addNewItem()
                }
                Button("取消", role: .cancel) {}
            }
        }
    }

    private func toggleSelection(_ item: T) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }

    private func addNewItem() {
        guard !newItemName.isEmpty else { return }
        let newItem = T(name: newItemName)
        modelContext.insert(newItem)
        // 自動選取新項目
        selectedItems.insert(newItem)
        newItemName = ""
    }
}
