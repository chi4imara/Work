import SwiftUI

struct AppColors {
    static let primaryBackground = Color.white
    static let purpleGradientStart = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let purpleGradientEnd = Color(red: 0.8, green: 0.6, blue: 1.0)
    static let blueText = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let yellowAccent = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let softPink = Color(red: 0.95, green: 0.85, blue: 0.9)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.35)
    static let successGreen = Color(red: 0.2, green: 0.7, blue: 0.4)
    static let warningRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBackground, softPink, purpleGradientStart.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.white, lightGray],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [purpleGradientStart, purpleGradientEnd],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    static let appPrimary = AppColors.purpleGradientStart
    static let appSecondary = AppColors.blueText
    static let appAccent = AppColors.yellowAccent
    static let appBackground = AppColors.primaryBackground
    static let appText = AppColors.darkGray
}
