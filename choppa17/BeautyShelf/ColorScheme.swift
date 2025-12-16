import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, primaryYellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.9)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let darkText = Color.black
    static let lightText = Color.white
    
    static let accentPurple = primaryPurple
    static let warningRed = Color.red
    static let successGreen = Color.green
    
    static let buttonBackground = primaryPurple
    static let buttonText = Color.white
    static let secondaryButtonBackground = Color.white.opacity(0.2)
    
    static let tabBarBackground = Color.white.opacity(0.1)
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
