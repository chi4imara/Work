import SwiftUI

struct AppColors {
    static let white = Color.white
    static let lightGray = Color(red: 0.98, green: 0.98, blue: 0.99)
    static let softGray = Color(red: 0.95, green: 0.96, blue: 0.97)
    static let mediumGray = Color(red: 0.7, green: 0.7, blue: 0.75)
    static let darkGray = Color(red: 0.4, green: 0.4, blue: 0.45)
    
    static let blueText = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let lightBlue = Color(red: 0.3, green: 0.6, blue: 1.0)
    static let mediumBlue = Color(red: 0.25, green: 0.5, blue: 0.9)
    static let darkBlue = Color(red: 0.15, green: 0.35, blue: 0.7)
    
    static let yellow = Color(red: 1.0, green: 0.85, blue: 0.2)
    static let lightYellow = Color(red: 1.0, green: 0.95, blue: 0.5)
    static let darkYellow = Color(red: 0.9, green: 0.75, blue: 0.1)
    
    static let green = Color(red: 0.2, green: 0.75, blue: 0.4)
    static let lightGreen = Color(red: 0.4, green: 0.85, blue: 0.6)
    
    static let red = Color(red: 0.95, green: 0.3, blue: 0.3)
    static let lightRed = Color(red: 1.0, green: 0.5, blue: 0.5)
    
    static let purple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let lightPurple = Color(red: 0.75, green: 0.6, blue: 0.95)
    
    static let pink = Color(red: 1.0, green: 0.5, blue: 0.7)
    static let lightPink = Color(red: 1.0, green: 0.7, blue: 0.85)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 1.0, blue: 1.0),
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.92, green: 0.95, blue: 1.0),
            Color(red: 0.88, green: 0.93, blue: 0.98)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 1.0, blue: 1.0),
            Color(red: 0.98, green: 0.98, blue: 0.99)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let tabBarGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 1.0, blue: 1.0).opacity(0.98),
            Color(red: 0.97, green: 0.97, blue: 0.98).opacity(0.98)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let likedColor = green
    static let neutralColor = mediumBlue
    static let dislikedColor = red
}

extension Color {
    static let appWhite = AppColors.white
    static let appLightGray = AppColors.lightGray
    static let appSoftGray = AppColors.softGray
    static let appMediumGray = AppColors.mediumGray
    static let appDarkGray = AppColors.darkGray
    
    static let appBlueText = AppColors.blueText
    static let appLightBlue = AppColors.lightBlue
    static let appMediumBlue = AppColors.mediumBlue
    static let appDarkBlue = AppColors.darkBlue
    
    static let appYellow = AppColors.yellow
    static let appLightYellow = AppColors.lightYellow
    static let appDarkYellow = AppColors.darkYellow
    
    static let appGreen = AppColors.green
    static let appLightGreen = AppColors.lightGreen
    
    static let appRed = AppColors.red
    static let appLightRed = AppColors.lightRed
    
    static let appPurple = AppColors.purple
    static let appLightPurple = AppColors.lightPurple
    
    static let appPink = AppColors.pink
    static let appLightPink = AppColors.lightPink
}
