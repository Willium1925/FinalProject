
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

        Group {
            if ideas.isEmpty {
                ContentUnavailableView("沒有符合條件的點子", systemImage: "tray.fill")
            } else {
                List {
                    ForEach(ideas) { idea in
                        NavigationLink(destination: IdeaDetailView(idea: idea)) {
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
        }
        .toolbar {
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
            AddIdeaView(defaultScene: scene, defaultTag: tag)
        }
    }
}
