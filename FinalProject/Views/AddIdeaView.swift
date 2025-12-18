
import SwiftUI
import SwiftData

struct AddIdeaView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Scene.name) private var scenes: [Scene]
    @Query(sort: \Tag.name) private var tags: [Tag]
    @Query(sort: \Source.name) private var sources: [Source]

    @State private var content: String = ""
    @State private var note: String = ""
    @State private var selectedScene: Scene?
    @State private var selectedTags = Set<Tag>()
    @State private var selectedSource: Source?

    @State private var isShowingAddSceneAlert = false
    @State private var newSceneName = ""

    @State private var isShowingAddTagAlert = false
    @State private var newTagName = ""

    @State private var isShowingAddSourceAlert = false
    @State private var newSourceName = ""

    // 用來判斷是新增還是編輯
    var ideaToEdit: Idea?

    init(ideaToEdit: Idea? = nil, defaultScene: Scene? = nil, defaultTag: Tag? = nil) {
        self.ideaToEdit = ideaToEdit

        // 根據模式初始化
        if let idea = ideaToEdit {
            _content = State(initialValue: idea.content)
            _note = State(initialValue: idea.note)
            _selectedScene = State(initialValue: idea.scenes.first)
            _selectedTags = State(initialValue: Set(idea.tags))
            _selectedSource = State(initialValue: idea.source)
        } else {
            _selectedScene = State(initialValue: defaultScene)
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
                        Text("內文")
                            .font(.headline)
                        TextField("請輸入那句話...", text: $content, axis: .vertical)
                            .lineLimit(3...6)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.vertical, 4)

                    VStack(alignment: .leading) {
                        Text("備註")
                            .font(.headline)
                        TextEditor(text: $note)
                            .frame(minHeight: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("內容")
                }

                Section("來源") {
                    Picker("選擇來源", selection: $selectedSource) {
                        Text("無").tag(nil as Source?)
                        ForEach(sources) { source in
                            Text(source.name).tag(source as Source?)
                        }
                    }
                    Button(action: { isShowingAddSourceAlert = true }) {
                        Label("新增來源", systemImage: "plus.circle")
                    }
                }

                Section("場景") {
                    Picker("選擇場景", selection: $selectedScene) {
                        Text("無").tag(nil as Scene?)
                        ForEach(scenes) { scene in
                            Text(scene.name).tag(scene as Scene?)
                        }
                    }
                    Button(action: { isShowingAddSceneAlert = true }) {
                        Label("新增場景", systemImage: "plus.circle")
                    }
                }

                Section("標籤") {
                    ForEach(tags) { tag in
                        HStack {
                            Text(tag.name)
                            Spacer()
                            if selectedTags.contains(tag) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }
                    }

                    Button(action: { isShowingAddTagAlert = true }) {
                        Label("新增標籤", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle(ideaToEdit == nil ? "新增點子" : "編輯點子")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") {
                        save()
                        dismiss()
                    }
                    .disabled(content.isEmpty)
                }
            }
            .alert("新增場景", isPresented: $isShowingAddSceneAlert) {
                TextField("場景名稱", text: $newSceneName)
                Button("新增") { addNewScene() }
                Button("取消", role: .cancel) { }
            }
            .alert("新增標籤", isPresented: $isShowingAddTagAlert) {
                TextField("標籤名稱", text: $newTagName)
                Button("新增") { addNewTag() }
                Button("取消", role: .cancel) { }
            }
            .alert("新增來源", isPresented: $isShowingAddSourceAlert) {
                TextField("來源名稱", text: $newSourceName)
                Button("新增") { addNewSource() }
                Button("取消", role: .cancel) { }
            }
        }
    }

    private func save() {
        if let idea = ideaToEdit {
            // 編輯模式
            idea.content = content
            idea.note = note
            idea.source = selectedSource
            idea.scenes = selectedScene != nil ? [selectedScene!] : []
            idea.tags = Array(selectedTags)
        } else {
            // 新增模式
            let newIdea = Idea(content: content, note: note)
            newIdea.source = selectedSource
            if let selectedScene {
                newIdea.scenes = [selectedScene]
            }
            newIdea.tags = Array(selectedTags)
            modelContext.insert(newIdea)
        }
    }

    private func addNewScene() {
        let newScene = Scene(name: newSceneName)
        modelContext.insert(newScene)
        newSceneName = ""
        selectedScene = newScene
    }

    private func addNewTag() {
        let newTag = Tag(name: newTagName)
        modelContext.insert(newTag)
        newTagName = ""
        selectedTags.insert(newTag)
    }

    private func addNewSource() {
        let newSource = Source(name: newSourceName)
        modelContext.insert(newSource)
        newSourceName = ""
        selectedSource = newSource
    }
}

#Preview {
    AddIdeaView()
        .modelContainer(for: Idea.self, inMemory: true)
}
