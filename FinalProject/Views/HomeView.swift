
import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Idea.createdAt, order: .reverse) private var allIdeas: [Idea]
    @Query(sort: \Source.name) private var sources: [Source]

    @State private var isAddingIdea = false
    @State private var selectedSource: Source? // nil 代表顯示全部

    // 過濾後的 ideas
    var filteredIdeas: [Idea] {
        if let selectedSource {
            return selectedSource.ideas.sorted { $0.createdAt > $1.createdAt }
        } else {
            return allIdeas
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // 頂部來源選擇列
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            // "全部" 選項
                            SourceFilterPill(
                                title: "全部",
                                isSelected: selectedSource == nil,
                                action: { selectedSource = nil }
                            )

                            // 各個來源選項
                            ForEach(sources) { source in
                                SourceFilterPill(
                                    title: source.name,
                                    isSelected: selectedSource == source,
                                    action: { selectedSource = source }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .background(Color(uiColor: .systemBackground))

                    // 下方卡片列表
                    if filteredIdeas.isEmpty {
                        ContentUnavailableView("這裡還沒有點子", systemImage: "lightbulb.slash")
                            .frame(maxHeight: .infinity)
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredIdeas) { idea in
                                    NavigationLink(destination: IdeaDetailView(idea: idea)) {
                                        IdeaCardView(idea: idea)
                                            .containerRelativeFrame(.vertical, count: 4, spacing: 16)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .scrollTargetLayout()
                            .padding(.vertical, 20)
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .contentMargins(.horizontal, 20, for: .scrollContent)
                    }
                }
            }
            .navigationTitle("靈感來源")
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

// 來源過濾按鈕元件
struct SourceFilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(uiColor: .secondarySystemFill))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(Color.blue.opacity(0.3), lineWidth: isSelected ? 0 : 0.5)
                )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3), value: isSelected)
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

                // 內文
                Text(idea.content)
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .padding(.horizontal, 4)

                // 備註
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
