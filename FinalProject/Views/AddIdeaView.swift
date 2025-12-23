
import SwiftUI
import SwiftData

struct AddIdeaView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Source.name) private var sources: [Source]

    @State private var content: String = ""
    @State private var note: String = ""
    @State private var selectedScenes = Set<Scene>()
    @State private var selectedTags = Set<Tag>()
    @State private var selectedSource: Source?

    @State private var isShowingSceneSelector = false
    @State private var isShowingTagSelector = false

    @State private var isShowingAddSourceAlert = false
    @State private var newSourceName = ""

    var ideaToEdit: Idea?

    init(ideaToEdit: Idea? = nil, defaultScene: Scene? = nil, defaultTag: Tag? = nil) {
        self.ideaToEdit = ideaToEdit

        if let idea = ideaToEdit {
            _content = State(initialValue: idea.content)
            _note = State(initialValue: idea.note)
            _selectedScenes = State(initialValue: Set(idea.scenes))
            _selectedTags = State(initialValue: Set(idea.tags))
            _selectedSource = State(initialValue: idea.source)
        } else {
            if let defaultScene {
                _selectedScenes = State(initialValue: [defaultScene])
            }
            if let defaultTag {
                _selectedTags = State(initialValue: [defaultTag])
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("內文").font(.headline)
                        TextField("請輸入那句話...", text: $content, axis: .vertical).lineLimit(3...6).textFieldStyle(.roundedBorder)
                    }
                    .padding(.vertical, 4)

                    VStack(alignment: .leading) {
                        Text("備註").font(.headline)
                        TextEditor(text: $note).frame(minHeight: 100).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    }
                    .padding(.vertical, 4)
                } header: { Text("內容") }

                Section("來源") {
                    Picker("選擇來源", selection: $selectedSource) {
                        Text("無").tag(nil as Source?)
                        ForEach(sources) { source in Text(source.name).tag(source as Source?) }
                    }
                    Button(action: { isShowingAddSourceAlert = true }) { Label("新增來源", systemImage: "plus.circle") }
                }

                Section("場景") {
                    ItemCapsuleListView(items: selectedScenes, placeholder: "未選擇場景")
                    Button(action: { isShowingSceneSelector = true }) { Label("加入場景", systemImage: "plus.circle") }
                }

                Section("標籤") {
                    ItemCapsuleListView(items: selectedTags, placeholder: "未選擇標籤")
                    Button(action: { isShowingTagSelector = true }) { Label("加入標籤", systemImage: "plus.circle") }
                }
            }
            .navigationTitle(ideaToEdit == nil ? "新增內容" : "編輯內容")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("取消") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("儲存") { save(); dismiss() }.disabled(content.isEmpty) }
            }
            .sheet(isPresented: $isShowingSceneSelector) { SelectionView(selectedItems: $selectedScenes, title: "場景") }
            .sheet(isPresented: $isShowingTagSelector) { SelectionView(selectedItems: $selectedTags, title: "標籤") }
            .alert("新增來源", isPresented: $isShowingAddSourceAlert) {
                TextField("來源名稱", text: $newSourceName)
                Button("新增") { addNewSource() }
                Button("取消", role: .cancel) { }
            }
        }
    }

    private func save() {
        if let idea = ideaToEdit {
            idea.content = content
            idea.note = note
            idea.source = selectedSource
            idea.scenes = Array(selectedScenes)
            idea.tags = Array(selectedTags)
        } else {
            let newIdea = Idea(content: content, note: note)
            newIdea.source = selectedSource
            newIdea.scenes = Array(selectedScenes)
            newIdea.tags = Array(selectedTags)
            modelContext.insert(newIdea)
        }
    }

    private func addNewSource() {
        let newSource = Source(name: newSourceName)
        modelContext.insert(newSource)
        newSourceName = ""
        selectedSource = newSource
    }
}

// 膠囊列表的輔助 View
struct ItemCapsuleListView<T: Nameable>: View {
    let items: Set<T>
    let placeholder: String

    var body: some View {
        if items.isEmpty {
            Text(placeholder)
                .foregroundColor(.secondary)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(items).sorted(by: { $0.name < $1.name })) { item in
                        Text(item.name)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}
