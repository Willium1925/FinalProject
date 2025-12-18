
import SwiftUI
import SwiftData

struct IdeaDetailView: View {
    @Bindable var idea: Idea
    @State private var isEditing = false

    private static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter
    }()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 內文
                    Text(idea.content)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    // 備註
                    if !idea.note.isEmpty {
                        Text(idea.note)
                            .font(.body)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading) // 關鍵修改：讓寬度撐滿
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }

                    // 來源、場景、標籤
                    VStack(alignment: .leading, spacing: 16) {
                        if let source = idea.source {
                            DetailRow(icon: "lightbulb", title: "來源", content: source.name)
                        }
                        if !idea.scenes.isEmpty {
                            DetailRow(icon: "film.stack", title: "場景", content: idea.scenes.map(\.name).joined(separator: ", "))
                        }
                        if !idea.tags.isEmpty {
                            DetailRow(icon: "tag", title: "標籤", content: idea.tags.map(\.name).joined(separator: ", "))
                        }
                        DetailRow(icon: "calendar", title: "建立時間", content: Self.relativeFormatter.localizedString(for: idea.createdAt, relativeTo: Date()))
                    }
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
        .navigationTitle("詳細資訊")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("編輯") {
                    isEditing = true
                }
                .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $isEditing) {
            AddIdeaView(ideaToEdit: idea)
        }
    }
}

// 詳情頁的輔助 View
struct DetailRow: View {
    let icon: String
    let title: String
    let content: String

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundColor(.gray)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(content)
                    .foregroundColor(.white)
            }

            Spacer()
        }
    }
}
