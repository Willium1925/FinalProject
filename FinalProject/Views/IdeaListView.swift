
import SwiftUI
import SwiftData

struct IdeaListView: View {
    let scene: Scene

    var body: some View {
        List(scene.ideas ?? []) { idea in
            VStack(alignment: .leading) {
                Text(idea.content)
                if !idea.note.isEmpty {
                    Text(idea.note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(scene.name)
    }
}
