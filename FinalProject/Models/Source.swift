
import Foundation
import SwiftData

@Model
final class Source {
    @Attribute(.unique) var name: String
    var ideas: [Idea] = []

    init(name: String) {
        self.name = name
    }
}
