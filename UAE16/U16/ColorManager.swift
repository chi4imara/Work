import SwiftUI

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    static let primaryBackground = LinearGradient(
        colors: [
            Color(red: 0.1, green: 0.15, blue: 0.3),
            Color(red: 0.05, green: 0.1, blue: 0.2),
            Color(red: 0.15, green: 0.2, blue: 0.35)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.8)
    static let cardBackgroundSecondary = Color(red: 0.2, green: 0.25, blue: 0.4).opacity(0.6)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 0.4, green: 0.8, blue: 1.0)
    
    static let primaryAccent = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let secondaryAccent = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let successColor = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningColor = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let errorColor = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let primaryButton = LinearGradient(
        colors: [
            Color(red: 0.4, green: 0.8, blue: 1.0),
            Color(red: 0.2, green: 0.6, blue: 0.9)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let secondaryButton = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.6, blue: 0.2),
            Color(red: 0.9, green: 0.5, blue: 0.1)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let dangerButton = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.3, blue: 0.3),
            Color(red: 0.8, green: 0.2, blue: 0.2)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let tabBarBackground = Color(red: 0.1, green: 0.15, blue: 0.3).opacity(0.95)
    static let tabBarSelected = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let tabBarUnselected = Color.white.opacity(0.6)
    
    static let chartLine = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let chartFill = LinearGradient(
        colors: [
            Color(red: 0.4, green: 0.8, blue: 1.0).opacity(0.3),
            Color.clear
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let muscleGroupColors: [String: Color] = [
        "Chest": Color(red: 1.0, green: 0.6, blue: 0.2),
        "Back": Color(red: 0.4, green: 0.8, blue: 1.0),
        "Legs": Color(red: 0.2, green: 0.8, blue: 0.4),
        "Shoulders": Color(red: 1.0, green: 0.8, blue: 0.2),
        "Arms": Color(red: 1.0, green: 0.3, blue: 0.3),
        "Cardio": Color(red: 0.8, green: 0.4, blue: 1.0),
        "Other": Color.white.opacity(0.7)
    ]
}
