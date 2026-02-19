import SwiftUI

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let white = Color.white
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let mediumGray = Color(red: 0.6, green: 0.6, blue: 0.6)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let primaryGradient = LinearGradient(
        colors: [darkBlue, Color(red: 0.15, green: 0.2, blue: 0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [Color(red: 0.05, green: 0.1, blue: 0.25), darkBlue],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let accentGradient = LinearGradient(
        colors: [lightBlue, orange],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let primaryText = white
    static let secondaryText = lightGray
    static let accentText = lightBlue
    
    static let primaryButton = lightBlue
    static let secondaryButton = orange
    static let dangerButton = Color.red
    
    static let cardBackground = Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.8)
    static let overlayBackground = Color.black.opacity(0.3)
}

extension Color {
    static var theme: ColorManager.Type {
        return ColorManager.self
    }
}
