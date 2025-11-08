import SwiftUI

struct AppColors {
    static let background = Color.black
    static let primaryText = Color.yellow
    static let secondaryText = Color.white
    static let accent = Color.yellow
    
    static let cardBackground = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let darkGray = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let lightGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.black,
            Color(red: 0.05, green: 0.05, blue: 0.1),
            Color(red: 0.1, green: 0.05, blue: 0.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.15, green: 0.15, blue: 0.15),
            Color(red: 0.1, green: 0.1, blue: 0.1)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let tabBarBackground = Color(red: 0.05, green: 0.05, blue: 0.05)
    static let tabBarSelected = Color.yellow
    static let tabBarUnselected = Color.gray
}

extension Color {
    static let appBackground = AppColors.background
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appAccent = AppColors.accent
    static let appCardBackground = AppColors.cardBackground
}
