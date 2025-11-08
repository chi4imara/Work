import SwiftUI

struct ColorTheme {
    static let background = Color.black
    static let primaryText = Color.yellow
    static let secondaryText = Color.white
    static let accent = Color.orange
    
    static let cardBackground = Color.gray.opacity(0.2)
    static let borderColor = Color.gray.opacity(0.3)
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.black,
            Color.gray.opacity(0.8),
            Color.black
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.gray.opacity(0.3),
            Color.gray.opacity(0.1)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let tabBarBackground = Color.black.opacity(0.9)
    static let tabBarSelected = Color.yellow
    static let tabBarUnselected = Color.gray
}

