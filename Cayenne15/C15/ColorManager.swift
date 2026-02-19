import SwiftUI

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let white = Color.white
    
    static let gray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let green = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let red = Color(red: 0.9, green: 0.3, blue: 0.3)
    
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
    static let secondaryText = Color(red: 0.8, green: 0.8, blue: 0.8)
    static let accentText = lightBlue
}
