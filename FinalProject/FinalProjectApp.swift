
import SwiftUI
import SwiftData

@main
struct FinalProjectApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Idea.self,
            Source.self,
            Tag.self,
            Scene.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // 明確指定這裡是 SwiftUI.Scene，避免與 Model 的 Scene 衝突
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
