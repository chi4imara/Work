import SwiftUI

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    let primaryBackground = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.1, green: 0.15, blue: 0.3),
            Color(red: 0.05, green: 0.1, blue: 0.25),
            Color(red: 0.15, green: 0.2, blue: 0.35)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let primaryText = Color.white
    let secondaryText = Color.white.opacity(0.8)
    
    let accentBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    let accentOrange = Color(red: 1.0, green: 0.5, blue: 0.2)
    
    let cardBackground = Color.white.opacity(0.1)
    let buttonBackground = Color.white.opacity(0.15)
    let selectedBackground = Color.white.opacity(0.2)
    
    let successColor = Color.green
    let errorColor = Color.red
    let warningColor = Color.yellow
    
    let tabBarBackground = Color.black.opacity(0.3)
    let tabBarSelected = Color.white
    let tabBarUnselected = Color.white.opacity(0.6)
}
