import SwiftUI

struct AppColors {
    static let primary = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondary = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let background = Color.white
    static let cardBackground = Color.white.opacity(0.9)
    static let textPrimary = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let textSecondary = Color.gray
    static let accent = Color(red: 0.9, green: 0.3, blue: 0.5)
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let backgroundGradient = LinearGradient(
        colors: [Color.white, Color(red: 0.95, green: 0.97, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.white, Color(red: 0.98, green: 0.99, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
