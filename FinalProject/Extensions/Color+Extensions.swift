
import SwiftUI

extension Color {
    static func random(seed: String) -> Color {
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(u.value)
        }

        srand48(total * 200)
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())

        return Color(red: r, green: g, blue: b)
    }

    static func gradient(seed: String) -> LinearGradient {
        let color1 = Color.random(seed: seed)
        let color2 = Color.random(seed: String(seed.reversed()))

        return LinearGradient(
            gradient: Gradient(colors: [color1, color2]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
