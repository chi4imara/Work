import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.5, blue: 0.2)
    static let white = Color.white
    
    static let primaryBackground = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.05, green: 0.1, blue: 0.25),
            Color(red: 0.15, green: 0.2, blue: 0.35)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(red: 0.2, green: 0.25, blue: 0.4).opacity(0.8)
    static let surfaceBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.7)
    static let accentText = Color(red: 0.2, green: 0.6, blue: 0.9)
    
    static let primaryButton = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let secondaryButton = Color(red: 1.0, green: 0.5, blue: 0.2)
    static let destructiveButton = Color.red
    
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    static let separator = Color.white.opacity(0.2)
}

struct BackgroundView: View {
    var body: some View {
        AppColors.primaryBackground
            .ignoresSafeArea()
    }
}
