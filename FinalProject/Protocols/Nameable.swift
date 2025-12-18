
import Foundation
import SwiftData

protocol Nameable: PersistentModel {
    var name: String { get set }
    init(name: String)
}
