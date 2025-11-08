import SwiftUI

struct AppColors {
    static let primaryPurple = Color(red: 0.4, green: 0.2, blue: 0.8)
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryPurple, primaryBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let cardText = Color.black
    static let cardSecondaryText = Color.black.opacity(0.6)
    
    static let accentBlue = Color(red: 0.0, green: 0.5, blue: 1.0)
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let errorRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let takenStatus = successGreen
    static let missedStatus = errorRed
    static let unmarkedStatus = warningYellow
    
    static let primaryButton = accentBlue
    static let secondaryButton = Color.white.opacity(0.2)
    static let destructiveButton = errorRed
    
    static let cardBackground = Color.white.opacity(0.9)
    static let cardShadow = Color.black.opacity(0.1)
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
                        endRadius: 500
                    )
                )
                .ignoresSafeArea()
        }
    }
}

extension View {
    func appBackground() -> some View {
        self.background(BackgroundView())
    }
}
