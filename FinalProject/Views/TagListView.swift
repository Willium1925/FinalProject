
import SwiftUI
import SwiftData

struct TagListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tag.name) private var allTags: [Tag]

    @State private var selectedTags = Set<Tag>()
    @State private var isAddingIdea = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // 頂部標籤選擇器
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(allTags) { tag in
                                Button(action: {
                                    toggleTagSelection(tag)
                                }) {
                                    Text(tag.name)
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedTags.contains(tag) ? Color.blue : Color.white.opacity(0.1))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .animation(.spring(response: 0.3), value: selectedTags.contains(tag))
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(height: 60)

                    Divider().background(Color.gray)

                    // 根據是否有選擇來顯示不同內容
                    if selectedTags.isEmpty {
                        ContentUnavailableView("請選擇標籤進行篩選", systemImage: "tag.circle")
                            .preferredColorScheme(.dark)
                            .frame(maxHeight: .infinity)
                    } else {
                        // 顯示篩選結果
                        FilteredIdeaListView(selectedTags: selectedTags)
                    }
                }
            }
            .navigationTitle("標籤篩選")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { isAddingIdea = true }) {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $isAddingIdea) {
                AddIdeaView()
            }
            .onAppear(perform: addSampleData)
        }
    }

    private func toggleTagSelection(_ tag: Tag) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }

    private func addSampleData() {
        if allTags.isEmpty {
            modelContext.insert(Tag(name: "正能量"))
            modelContext.insert(Tag(name: "生活小聰明"))
            modelContext.insert(Tag(name: "再想想"))
            modelContext.insert(Tag(name: "靈光一閃"))
        }
    }
}

#Preview {
    TagListView()
        .modelContainer(for: Tag.self, inMemory: true)
}
