import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.7)
    static let accentText = Color(red: 0.9, green: 0.9, blue: 0.9)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, primaryYellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBackgroundSecondary = Color.white.opacity(0.1)
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let accent = primaryPurple
    
    static let tabBarBackground = Color.black.opacity(0.3)
    static let tabBarSelected = primaryYellow
    static let tabBarUnselected = Color.white.opacity(0.6)
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Rectangle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.clear,
                            Color.black.opacity(0.1)
                        ],
                        center: .topTrailing,
                        startRadius: 100,
                        endRadius: 400
                    )
                )
                .ignoresSafeArea()
        }
    }
}
