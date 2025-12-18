
import Foundation
import SwiftData

@Model
final class Tag: Nameable {
    @Attribute(.unique) var name: String
    var ideas: [Idea] = []

    init(name: String) {
        self.name = name
    }
}
