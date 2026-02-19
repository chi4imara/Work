import SwiftUI

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    static let textBlue = Color(red: 0.1, green: 0.4, blue: 0.8)
    
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.98, green: 0.99, blue: 1.0),
            Color(red: 0.95, green: 0.98, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.9),
            Color(red: 0.99, green: 0.99, blue: 1.0).opacity(0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension ColorManager {
    static let bubbleColors: [Color] = [
        primaryBlue.opacity(0.3),
        primaryBlue.opacity(0.2),
        primaryBlue.opacity(0.4),
        accentPurple.opacity(0.2),
        accentGreen.opacity(0.2)
    ]
}
