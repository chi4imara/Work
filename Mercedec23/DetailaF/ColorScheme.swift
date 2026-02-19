import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    static let textBlue = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let bubbleBlue = Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightGray],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [backgroundWhite, lightGray.opacity(0.5)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [primaryYellow, primaryYellow.opacity(0.8)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct AppConstants {
    static let cornerRadius: CGFloat = 16
    static let shadowRadius: CGFloat = 8
    static let animationDuration: Double = 0.3
    static let cardPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 24
    
    static let buttonHeight: CGFloat = 50
    static let cardHeight: CGFloat = 200
    static let imageSize: CGFloat = 120
    static let iconSize: CGFloat = 24
    
    static let bubbleCount = 15
    static let bubbleMinSize: CGFloat = 20
    static let bubbleMaxSize: CGFloat = 80
    static let bubbleAnimationDuration: Double = 8.0
}
