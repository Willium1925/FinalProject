
import SwiftUI
import SwiftData

struct FilteredIdeaListView: View {
    @Query private var allIdeas: [Idea]

    private var scene: Scene?
    private var tag: Tag?
    private var searchText: String

    @State private var isAddingIdea = false

    init(searchText: String = "", scene: Scene? = nil, tag: Tag? = nil) {
        self.searchText = searchText
        self.scene = scene
        self.tag = tag

        _allIdeas = Query(sort: \Idea.createdAt, order: .reverse)
    }

    var ideasToShow: [Idea] {
        if let scene {
            return scene.ideas.sorted { $0.createdAt > $1.createdAt }
        } else if let tag {
            return tag.ideas.sorted { $0.createdAt > $1.createdAt }
        } else if !searchText.isEmpty {
            return allIdeas.filter { idea in
                idea.content.localizedStandardContains(searchText) ||
                idea.note.localizedStandardContains(searchText)
            }
        } else {
            return allIdeas
        }
    }

    var body: some View {
        let ideas = ideasToShow

        // 使用 Group 來避免在 if/else 中重複 List 程式碼
        Group {
            if ideas.isEmpty {
                ContentUnavailableView("沒有符合條件的點子", systemImage: "tray.fill")
            } else {
                List(ideas) { idea in
                    VStack(alignment: .leading) {
                        Text(idea.content)
                            .fontWeight(.medium)
                        if !idea.note.isEmpty {
                            Text(idea.note)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .toolbar {
            // 只在場景或標籤頁面顯示 "+" 按鈕
            if scene != nil || tag != nil {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isAddingIdea = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingIdea) {
            // 傳遞預設值
            AddIdeaView(defaultScene: scene, defaultTag: tag)
        }
    }
}
