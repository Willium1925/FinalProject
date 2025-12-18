
import SwiftUI
import SwiftData

struct IdeaDetailView: View {
    @Bindable var idea: Idea
    @State private var isEditing = false

    // 建立一個靜態的 formatter，避免重複建立，並強制使用繁體中文
    private static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter
    }()

    var body: some View {
        Form {
            Section("內容") {
                Text(idea.content)
                    .font(.body)
            }

            if !idea.note.isEmpty {
                Section("備註") {
                    Text(idea.note)
                }
            }

            if let source = idea.source {
                Section("來源") {
                    Text(source.name)
                }
            }

            if !idea.scenes.isEmpty {
                Section("場景") {
                    ForEach(idea.scenes) { scene in
                        Text(scene.name)
                    }
                }
            }

            if !idea.tags.isEmpty {
                Section("標籤") {
                    ForEach(idea.tags) { tag in
                        Text(tag.name)
                    }
                }
            }

            Section("建立時間") {
                // 使用原生的 RelativeDateTimeFormatter
                Text(Self.relativeFormatter.localizedString(for: idea.createdAt, relativeTo: Date()))
            }
        }
        .navigationTitle("詳細資訊")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("編輯") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            AddIdeaView(ideaToEdit: idea)
        }
    }
}
