
import Foundation
import SwiftData

// 定義一個標準：必須是 SwiftData 的模型 (PersistentModel)，而且必須有個名字
protocol Nameable: PersistentModel {
    var name: String { get set }
    init(name: String)
}
