import SwiftUI

struct AppColors {
    static let primary = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let accent = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let background = Color.white
    static let textPrimary = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let cardBackground = Color(red: 0.98, green: 0.98, blue: 1.0) 
    static let shadow = Color.black.opacity(0.1)
    static let gradient = LinearGradient(
        colors: [
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.98, green: 0.95, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
