//
//  Item.swift
//  FinalProject
//
//  Created by Demo0820 on 2025/12/19.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
