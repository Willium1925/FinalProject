
import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Idea.createdAt, order: .reverse) private var ideas: [Idea]
    @State private var isAddingIdea = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()

                if ideas.isEmpty {
                    ContentUnavailableView("還沒有點子", systemImage: "lightbulb.slash")
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            ForEach(ideas) { idea in
                                NavigationLink(destination: IdeaDetailView(idea: idea)) {
                                    IdeaCardView(idea: idea)
                                        // 關鍵修改：讓高度大約是螢幕的 1/3.5，製造拉霸機的密集感
                                        .containerRelativeFrame(.vertical, count: 4, spacing: 16)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .scrollTargetLayout() // 配合 viewAligned 使用
                        .padding(.vertical, 20)
                    }
                    .scrollTargetBehavior(.viewAligned) // 讓滾動有吸附感，像拉霸機一樣
                    .contentMargins(.horizontal, 20, for: .scrollContent)
                }
            }
            .navigationTitle("每日靈感")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isAddingIdea = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingIdea) {
                AddIdeaView()
            }
        }
    }
}

struct IdeaCardView: View {
    let idea: Idea

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

            VStack(alignment: .center, spacing: 8) {
                // 來源 (如果有的話)
                if let source = idea.source {
                    Text(source.name)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }

                // 內文 (限制行數，保持卡片整齊)
                Text(idea.content)
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .padding(.horizontal, 4)

                // 備註 (如果有的話，顯示一行)
                if !idea.note.isEmpty {
                    Text(idea.note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(12)
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Idea.self, inMemory: true)
}
