
import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            FilteredIdeaListView(searchText: searchText)
                .navigationTitle("搜尋")
        }
        .searchable(text: $searchText, prompt: "搜尋內文或備註")
    }
}

#Preview {
    SearchView()
}
