
import Foundation
import SwiftData

@Model
final class Idea {
    var content: String
    var note: String
    var createdAt: Date

    @Relationship(inverse: \Source.ideas)
    var source: Source?

    @Relationship(inverse: \Tag.ideas)
    var tags: [Tag] = []

    @Relationship(inverse: \Scene.ideas)
    var scenes: [Scene] = []

    init(content: String, note: String = "", createdAt: Date = .now) {
        self.content = content
        self.note = note
        self.createdAt = createdAt
    }
}
