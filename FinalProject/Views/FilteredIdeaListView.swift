
import SwiftUI
import SwiftData

struct FilteredIdeaListView: View {
    // 1. 用來處理搜尋的情況
    @Query private var allIdeas: [Idea]

    // 2. 用來接收傳入的過濾條件
    private var scene: Scene?
    private var tag: Tag?
    private var searchText: String

    init(searchText: String = "", scene: Scene? = nil, tag: Tag? = nil) {
        self.searchText = searchText
        self.scene = scene
        self.tag = tag

        // 如果有搜尋文字，我們就查詢所有 Idea，然後在 body 裡過濾
        // 這裡只做最簡單的排序查詢，不做複雜的 filter
        _allIdeas = Query(sort: \Idea.createdAt, order: .reverse)
    }

    var ideasToShow: [Idea] {
        if let scene {
            // 如果是場景模式，直接回傳該場景的 ideas
            return scene.ideas.sorted { $0.createdAt > $1.createdAt }
        } else if let tag {
            // 如果是標籤模式，直接回傳該標籤的 ideas
            return tag.ideas.sorted { $0.createdAt > $1.createdAt }
        } else if !searchText.isEmpty {
            // 如果是搜尋模式，在記憶體中過濾
            return allIdeas.filter { idea in
                idea.content.localizedStandardContains(searchText) ||
                idea.note.localizedStandardContains(searchText)
            }
        } else {
            // 預設情況（雖然目前邏輯不會走到這，但為了安全）
            return allIdeas
        }
    }

    var body: some View {
        let ideas = ideasToShow

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
}
