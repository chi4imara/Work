import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 0.95)
    static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.7)
    
    static let yellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let lightYellow = Color(red: 1.0, green: 0.9, blue: 0.4)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, lightBlue, darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let buttonPrimary = yellow
    static let buttonSecondary = Color.white.opacity(0.2)
    static let buttonText = Color.black
}

struct BackgroundView: View {
    var body: some View {
        AppColors.backgroundGradient
            .ignoresSafeArea()
    }
}
