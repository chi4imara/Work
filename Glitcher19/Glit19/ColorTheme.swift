import SwiftUI

struct ColorTheme {
    static let shared = ColorTheme()
    
    private init() {}
    
    let primaryPink = Color(red: 0.9, green: 0.3, blue: 0.6)
    let secondaryPink = Color(red: 0.95, green: 0.4, blue: 0.7)
    let darkPink = Color(red: 0.8, green: 0.2, blue: 0.5)
    
    let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    let lightYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    
    let primaryText = Color.white
    let secondaryText = Color.white.opacity(0.8)
    let accentText = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    let cardBackground = Color.white.opacity(0.1)
    let overlayBackground = Color.black.opacity(0.3)
    
    let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    let errorRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    
    var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [primaryPink, secondaryPink, darkPink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var cardGradient: LinearGradient {
        LinearGradient(
            colors: [cardBackground, cardBackground.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension Color {
    static let theme = ColorTheme.shared
}
