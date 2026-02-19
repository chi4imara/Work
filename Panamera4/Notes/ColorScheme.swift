import SwiftUI

struct AppColors {
    static let primaryPink = Color(red: 0.96, green: 0.71, blue: 0.85)
    static let accentYellow = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let primaryWhite = Color.white
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.98, green: 0.76, blue: 0.89),
            Color(red: 0.94, green: 0.66, blue: 0.81),
            Color(red: 0.91, green: 0.56, blue: 0.73)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let errorRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    
    static let cardBackground = Color.white.opacity(0.9)
    static let surfaceBackground = Color.white.opacity(0.7)
}

extension View {
    func primaryBackground() -> some View {
        self.background(AppColors.backgroundGradient.ignoresSafeArea())
    }
}
