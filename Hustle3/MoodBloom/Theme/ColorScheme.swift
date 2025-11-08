import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.98)
    
    static let textPrimary = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let textLight = Color(red: 0.4, green: 0.7, blue: 1.0)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    
    static let moodVeryBad = Color(red: 1.0, green: 0.2, blue: 0.2)
    static let moodBad = Color(red: 1.0, green: 0.5, blue: 0.2)
    static let moodNeutral = Color(red: 0.8, green: 0.8, blue: 0.8)
    static let moodGood = Color(red: 0.5, green: 0.8, blue: 0.3)
    static let moodVeryGood = Color(red: 0.2, green: 0.8, blue: 0.2)
}

struct AppColors {
    static let primary = Color.primaryBlue
    static let secondary = Color.darkBlue
    static let accent = Color.lightBlue
    static let background = Color.backgroundWhite
    static let surface = Color.backgroundGray
    static let textPrimary = Color.textPrimary
    static let textSecondary = Color.textSecondary
    static let textAccent = Color.textLight
}
