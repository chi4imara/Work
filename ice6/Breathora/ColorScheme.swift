import SwiftUI

struct AppColors {
    static let primaryPurple = Color(red: 0.4, green: 0.2, blue: 0.8)
    static let secondaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let lightPurple = Color(red: 0.8, green: 0.7, blue: 0.95)
    
    static let blueText = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let yellowAccent = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let lightYellow = Color(red: 1.0, green: 0.9, blue: 0.6)
    
    static let backgroundWhite = Color.white
    static let softGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.92)
    
    static let darkText = Color(red: 0.1, green: 0.1, blue: 0.2)
    static let mediumText = Color(red: 0.3, green: 0.3, blue: 0.4)
    static let lightText = Color(red: 0.6, green: 0.6, blue: 0.7)
    
    static let purpleGradient = LinearGradient(
        colors: [primaryPurple, secondaryPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, softGray, lightPurple.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [backgroundWhite, softGray.opacity(0.5)],
        startPoint: .top,
        endPoint: .bottom
    )
}

extension Color {
    static var appPrimary: Color { AppColors.primaryPurple }
    static var appSecondary: Color { AppColors.secondaryPurple }
    static var appBlue: Color { AppColors.blueText }
    static var appYellow: Color { AppColors.yellowAccent }
    static var appBackground: Color { AppColors.backgroundWhite }
    static var appText: Color { AppColors.darkText }
}
