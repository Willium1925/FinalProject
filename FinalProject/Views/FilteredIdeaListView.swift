
import SwiftUI
import SwiftData

struct FilteredIdeaListView: View {
    @Query private var allIdeas: [Idea]

    private var scene: Scene?
    private var selectedTags: Set<Tag>?
    private var searchText: String

    @State private var isAddingIdea = false

    init(searchText: String = "", scene: Scene? = nil, selectedTags: Set<Tag>? = nil) {
        self.searchText = searchText
        self.scene = scene
        self.selectedTags = selectedTags

        _allIdeas = Query(sort: \Idea.createdAt, order: .reverse)
    }

    var ideasToShow: [Idea] {
        if let scene {
            return scene.ideas.sorted { $0.createdAt > $1.createdAt }
        } else if let selectedTags, !selectedTags.isEmpty {
            // 篩選出包含所有已選標籤的 Idea
            return allIdeas.filter { idea in
                selectedTags.isSubset(of: Set(idea.tags))
            }.sorted { $0.createdAt > $1.createdAt }
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

        ZStack {
            Color.black.ignoresSafeArea()

            Group {
                if ideas.isEmpty {
                    ContentUnavailableView("沒有符合條件的點子", systemImage: "tray.fill")
                        .preferredColorScheme(.dark)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(ideas) { idea in
                                NavigationLink(destination: IdeaDetailView(idea: idea)) {
                                    IdeaRowCardView(idea: idea)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .toolbar {
            if scene != nil || selectedTags != nil {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isAddingIdea = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $isAddingIdea) {
            AddIdeaView(defaultScene: scene, defaultTag: selectedTags?.first)
        }
    }
}

// 列表中的 Idea 卡片樣式
struct IdeaRowCardView: View {
    let idea: Idea

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(idea.content)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(2)

            if !idea.note.isEmpty {
                Text(idea.note)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            // 顯示標籤
            if !idea.tags.isEmpty {
                HStack {
                    ForEach(idea.tags.prefix(3)) { tag in
                        Text("#\(tag.name)")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}
